module Admin
  class DogsController < Admin::ApplicationController
    include AdministrateExportable::Exporter
  end
end
