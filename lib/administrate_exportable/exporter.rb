module AdministrateExportable
  module Exporter
    extend ActiveSupport::Concern

    included do
      exportable
    end

    class_methods do
      def exportable
        define_method(:export) do
          search_term = params[:search].to_s.strip
          resources = Administrate::Search.new(scoped_resource,
                                               dashboard,
                                               search_term).run
          resources = apply_collection_includes(resources)
          resources = order.apply(resources)

          csv_data = ExporterService.csv(dashboard, resource_class, resources)

          respond_to do |format|
            format.csv { send_data csv_data, filename: "#{resource_name.to_s.pluralize}-#{Date.today}.csv" }
          end
        end
      end
    end
  end
end
