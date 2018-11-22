module Admin
  class CatsController < Admin::ApplicationController
    include AdministrateExportable::Exporter
  end
end
