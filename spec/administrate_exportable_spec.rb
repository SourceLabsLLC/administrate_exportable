require "rails_helper"

RSpec.describe AdministrateExportable do
  it "has a version number" do
    expect(AdministrateExportable::VERSION).not_to be nil
  end

  it "has a PAGE_PARAM constant" do
    expect(AdministrateExportable::PAGE_PARAM).not_to be nil
  end
end
