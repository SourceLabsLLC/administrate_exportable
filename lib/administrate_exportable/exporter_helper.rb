module AdministrateExportable
  module ExporterHelper
    def export_button
      return unless controller.respond_to?(:export)

      link_to 'Export', url_for(action: :export, format: :csv), class: 'button'
    end
  end
end
