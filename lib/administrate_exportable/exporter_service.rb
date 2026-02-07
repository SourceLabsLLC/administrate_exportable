require "csv"

module AdministrateExportable
  class ExporterService
    def self.csv(dashboard, resource_class, resources)
      new(dashboard, resource_class, resources).csv
    end

    def initialize(dashboard, resource_class, resources)
      @dashboard = dashboard
      @resource_class = resource_class
      @resources = resources
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

    attr_reader :dashboard, :resource_class, :resources, :sanitizer

    def record_attribute(record, attribute_key, attribute_type)
      field = attribute_type.new(attribute_key, record.send(attribute_key), "index", resource: record)
      transform_on_export = attribute_type.respond_to?(:options) && attribute_type.options[:transform_on_export]

      if transform_on_export.is_a? Proc
        return transform_on_export.call(field)
      end

      case field.class.to_s
      when Administrate::Field::BelongsTo.to_s, Administrate::Field::HasOne.to_s, Administrate::Field::Polymorphic.to_s
        field.display_associated_resource if field.data
      when Administrate::Field::HasMany.to_s
        field.data&.count
      when Administrate::Field::DateTime.to_s
        field.datetime if field.data
      when Administrate::Field::Date.to_s
        field.date if field.data
      when Administrate::Field::Email.to_s, Administrate::Field::Select.to_s
        field.data
      when Administrate::Field::Password.to_s, Administrate::Field::String.to_s, Administrate::Field::Text.to_s
        field.truncate
      when Administrate::Field::Time.to_s
        field.data.strftime("%I:%M%p").to_s if field.data
      else
        field.to_s
      end
    end

    def headers
      attributes_to_export.map do |attribute_key, _|
        attr_key = attribute_key.to_s

        if attr_key.include?("_id")
          attr_key
        else
          I18n.t(
            "helpers.label.#{resource_class.name.downcase}.#{attr_key}",
            default: attr_key
          ).titleize
        end
      end
    end

    def attributes_to_export
      @attributes_to_export ||= dashboard.class::ATTRIBUTE_TYPES.select do |attribute_key, attribute_type|
        attribute_options = attribute_type.try(:options)

        !attribute_options || attribute_options[:export] != false
      end
    end

    def collection
      resources
    end
  end
end
