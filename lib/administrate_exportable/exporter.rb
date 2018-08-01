module AdministrateExportable
  module Exporter
    extend ActiveSupport::Concern

    included do
      exportable
      helper ExporterHelper
    end

    class_methods do
      def exportable
        define_method(:export) do
          csv_data = ExporterService.csv(dashboard, resource_class)

          respond_to do |format|
            format.csv { send_data csv_data, filename: "#{resource_name.to_s.pluralize}-#{Date.today}.csv" }
          end
        end
      end
    end
  end
end
