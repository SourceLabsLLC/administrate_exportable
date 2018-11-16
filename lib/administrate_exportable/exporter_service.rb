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

      view_string = ApplicationController.render(
        partial: field.to_partial_path,
        locals: { field: field }
      )

      sanitizer.sanitize(view_string.gsub!(/\n/, ''))
    end

    def headers
      attributes_to_export.map do |attribute_key, _|
        attribute_key = attribute_key.to_s

        return attribute_key if attribute_key.include?('_id')

        I18n.t(
          "helpers.label.#{resource_class.name}.#{attribute_key}",
          default: attribute_key,
        ).titleize
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
