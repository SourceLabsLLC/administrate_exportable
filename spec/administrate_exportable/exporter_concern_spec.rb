require 'rails_helper'

RSpec.describe 'Exporter Concern', type: :request do
  describe 'GET export' do
    it 'returns a csv file' do
      get export_admin_users_url(format: :csv)

      expect(response.header['Content-Type']).to include 'text/csv'
    end

    it 'calls ExporterService' do
      expect(AdministrateExportable::ExporterService).to receive(:csv)
        .with(an_instance_of(UserDashboard), User, User.all)

      get export_admin_users_url(format: :csv)
    end
  end
end
