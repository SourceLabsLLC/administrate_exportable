require "administrate_exportable/version"
require "administrate_exportable/exporter"

module AdministrateExportable
  extend ActiveSupport::Concern

  module ClassMethods
    def exportable
      define_method(:export) do
        csv_data = Exporter.csv(dashboard, resource_class)

        respond_to do |format|
          format.csv { send_data csv_data, filename: "#{resource_name.to_s.pluralize}-#{Date.today}.csv" }
        end
      end
    end
  end
end
