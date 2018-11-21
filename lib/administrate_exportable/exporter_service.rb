require 'csv'

module AdministrateExportable
  class ExporterService
    def self.csv(dashboard, resource_class, controller_instance)
      new(dashboard, resource_class, controller_instance).csv
    end

    def initialize(dashboard, resource_class, controller_instance)
      @dashboard = dashboard
      @resource_class = resource_class
      @sanitizer = Rails::Html::FullSanitizer.new
      @controller_instance = controller_instance
    end

    def csv
      CSV.generate(headers: true) do |csv|
        csv << headers

        collection.find_each do |record|
          csv << attributes_to_export.map do |attribute_key, attribute_type|
            record_attribute(record, attribute_key, attribute_type)
          end
        end
      end
    end

    private

    attr_reader :dashboard, :resource_class, :sanitizer, :controller_instance

    def record_attribute(record, attribute_key, attribute_type)
      field = attribute_type.new(attribute_key, record.send(attribute_key), 'index', resource: record)

      # Used this insted of Admin::ApplicationController.render
      # to improve speed of render
      view_string = controller_instance.render_to_string(
        partial: field.to_partial_path,
        formats: [:html],
        locals: { field: field }
      )

      sanitizer.sanitize(view_string.gsub!(/\n/, ''))
    end

    def headers
      attributes_to_export.map do |attribute_key, _|
        attr_key = attribute_key.to_s

        if attr_key.include?('_id')
          attr_key
        else
          I18n.t(
            "helpers.label.#{resource_class.name}.#{attr_key}",
            default: attr_key,
          ).titleize
        end
      end
    end

    def attributes_to_export
      @attributes_to_export ||= begin
        dashboard.class::ATTRIBUTE_TYPES.select do |attribute_key, attribute_type|
          attribute_options = attribute_type.try(:options)

          !attribute_options || attribute_options[:export]
        end
      end
    end

    def collection
      relation = resource_class.default_scoped
      resource_includes = dashboard.association_includes

      return relation if resource_includes.empty?

      relation.includes(*resource_includes)
    end
  end
end
