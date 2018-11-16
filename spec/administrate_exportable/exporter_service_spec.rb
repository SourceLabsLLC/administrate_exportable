require 'rails_helper'

RSpec.describe AdministrateExportable::ExporterService, type: :helper do
  describe '#csv' do
    it 'generates correct header' do
      user = User.create(first_name: 'John', last_name: 'Doe')
      Dog.create(name: 'Wolf', user: user)

      result = AdministrateExportable::ExporterService.csv(UserDashboard.new, User)
      header = result.split("\n").first

      expect(header).to eq 'Id,First Name,Last Name,Dogs'
    end

    it 'exports correct data' do
      user = User.create(first_name: 'John', last_name: 'Doe')
      Dog.create(name: 'Wolf', user: user)

      result = AdministrateExportable::ExporterService.csv(UserDashboard.new, User)
      data = result.split("\n").last

      expect(data).to eq '2,John,Doe,1'
    end
  end
end
