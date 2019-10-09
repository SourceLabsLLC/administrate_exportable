require 'rails_helper'

RSpec.describe AdministrateExportable::ExporterService, type: :helper do
  describe '#csv' do
    let(:result) { AdministrateExportable::ExporterService.csv(UserDashboard.new, User, User.all) }
    let(:exported_data) { result.split("\n").last.split(',') }

    before do
      user = User.create(first_name: 'John', last_name: 'Doe', email: 'john@email.com', password: '1234567891011213')
      user.dogs.create(name: 'Wolf', walk_time: DateTime.new(2018,2,3,4,5))
      user.create_cat(name: 'Black Panther')
    end

    it 'generates correct header' do
      header = result.split("\n").first

      expect(header).to eq 'Id,First Name,Last Name,Dogs,Cat,Email,Password,Created At,Updated At'
    end

    context 'exporting Field::Number' do
      it 'exports correct data' do
        expect(exported_data[0]).to eq "2"
      end
    end

    context 'exporting Field::String' do
      it 'exports correct data' do
        expect(exported_data[1]).to eq "John"
      end
    end

    context 'exporting Field::HasMany' do
      it 'exports correct data' do
        expect(exported_data[3]).to eq "1"
      end
    end

    context 'exporting Field::HasOne' do
      it 'exports correct data' do
        expect(exported_data[4]).to eq "Cat #5"
      end
    end

    context 'exporting field passing a proc using transform_on_export' do
      it 'exports correct data' do
        date = User.first.created_at.strftime("%F")

        expect(exported_data[7]).to eq date
      end
    end

    context 'exporting Field::Email' do
      it 'exports correct data' do
        expect(exported_data[5]).to eq 'john@email.com'
      end
    end

    context 'exporting Field::Password' do
      it 'exports correct data' do
        expect(exported_data[6]).to eq '••••••••••••••••'
      end
    end

    context 'exporting Field::DateTime' do
      it 'exports correct data' do
        data = result.split("\n").last.split('"').last
        updated_at = User.last.updated_at

        formatted_date = I18n.localize(
          updated_at.in_time_zone('UTC'),
          format: :default,
          default: updated_at
        )

        expect(data).to eq formatted_date
      end
    end

    context 'exporting Field::BelongsTo' do
      let(:result) { AdministrateExportable::ExporterService.csv(CatDashboard.new, Cat, Cat.all) }

      it 'exports correct data' do
        expect(exported_data[0]).to eq 'John Doe'
      end
    end

    context 'exporting foreign key as a Field::Number' do
      let(:result) { AdministrateExportable::ExporterService.csv(DogDashboard.new, Dog, Dog.all) }

      it "exports header values with sufix '_id'" do
        header = result.split("\n").first.split(',')

        expect(header[2]).to eq 'user_id'
      end

      it 'exports correct data' do
        expect(exported_data[2]).to eq '12'
      end
    end

    context 'exporting Field::Time' do
      let(:result) { AdministrateExportable::ExporterService.csv(DogDashboard.new, Dog, Dog.all) }

      it 'exports correct data' do
        expect(exported_data[4]).to eq '04:05AM'
      end
    end
  end
end
