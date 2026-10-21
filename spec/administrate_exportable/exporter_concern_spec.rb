require "rails_helper"

RSpec.describe "Exporter Concern", type: :request do
  describe "GET export" do
    it "returns a csv file" do
      get export_admin_users_url(format: :csv)

      expect(response.header["Content-Type"]).to include "text/csv"
    end

    it "calls ExporterService" do
      expect(AdministrateExportable::ExporterService).to receive(:csv)
        .with(an_instance_of(UserDashboard), User, User.all)

      get export_admin_users_url(format: :csv)
    end

    it "exports only records matching the search term" do
      User.create(first_name: "John", last_name: "Doe", email: "john@email.com")
      User.create(first_name: "Jane", last_name: "Roe", email: "jane@email.com")

      get export_admin_users_url(format: :csv, search: "Jane")

      rows = CSV.parse(response.body)
      expect(rows.size).to eq 2
      expect(rows[1][1]).to eq "Jane"
    end

    it "exports only headers when the search has no results" do
      get export_admin_users_url(format: :csv, search: "nobody")

      expect(response).to have_http_status(:ok)
      expect(CSV.parse(response.body).size).to eq 1
    end
  end

  describe "GET index" do
    it "renders an export link that bypasses Turbolinks/Turbo" do
      get admin_users_url(search: "John")

      link = Nokogiri::HTML(response.body).at_css("a[href*='/admin/users/export.csv']")
      expect(link).to be_present
      expect(link["href"]).to include("search=John")
      expect(link["data-turbolinks"]).to eq "false"
      expect(link["data-turbo"]).to eq "false"
    end
  end
end
