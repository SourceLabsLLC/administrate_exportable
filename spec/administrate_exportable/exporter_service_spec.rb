require 'rails_helper'

RSpec.describe AdministrateExportable::ExporterService, type: :helper do
  describe '#csv' do
    it 'generates correct header' do
      result = AdministrateExportable::ExporterService.csv(UserDashboard.new, User)
      header = result.split("\n").first

      expect(header).to eq 'Id,First Name,Last Name,Dogs,Cat'
    end

    it 'exports correct data' do
      user = User.create(first_name: 'John', last_name: 'Doe')
      user.dogs.create(name: 'Wolf')
      user.create_cat(name: 'Black Panther')

      result = AdministrateExportable::ExporterService.csv(UserDashboard.new, User)
      data = result.split("\n").last

      expect(data).to eq '1,John,Doe,1 dog,  Cat #1'
    end
  end
end
