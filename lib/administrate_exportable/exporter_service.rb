require 'csv'

module AdministrateExportable
  class ExporterService
    def self.csv(dashboard, resource_class)
      new(dashboard, resource_class).csv
    end

    def initialize(dashboard, resource_class)
      @dashboard = dashboard
      @resource_class = resource_class
      @sanitizer = Rails::Html::FullSanitizer.new
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

    attr_reader :dashboard, :resource_class, :sanitizer

    def record_attribute(record, attribute_key, attribute_type)
      field = attribute_type.new(attribute_key, record.send(attribute_key), 'index')

      # TODO Speed this up or figure out a better approach
      view_string = Administrate::ApplicationController.render(
        partial: field.to_partial_path,
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
