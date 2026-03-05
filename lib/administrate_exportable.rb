require "administrate_exportable/version"
require "administrate_exportable/exporter_service"
require "administrate_exportable/exporter"
require "administrate/version"

module AdministrateExportable
  PAGE_PARAM = (Gem::Version.create(Administrate::VERSION) >= Gem::Version.create("0.15.0")) ? "_page" : "page"

  class Engine < ::Rails::Engine
  end
end
