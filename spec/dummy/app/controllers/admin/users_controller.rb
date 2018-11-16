module Admin
  class UsersController < Admin::ApplicationController
    include AdministrateExportable::Exporter
  end
end
