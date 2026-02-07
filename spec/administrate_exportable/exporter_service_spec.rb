require "rails_helper"

RSpec.describe AdministrateExportable::ExporterService, type: :helper do
  describe "#csv" do
    let(:result) { AdministrateExportable::ExporterService.csv(UserDashboard.new, User, User.all) }
    let(:parsed_data) { CSV.parse(result) }

    before do
      user = User.create(first_name: "John", last_name: "Doe", email: "john@email.com", password: "1234567891011213", birthdate: "1990-01-15")
      user.dogs.create(name: "Wolf", walk_time: DateTime.new(2018, 2, 3, 4, 5))
      user.create_cat(name: "Black Panther")
    end

    it "generates correct header" do
      expect(parsed_data[0].join(",")).to eq "Id,First Name,Last Name,Dogs,Cat,Email,Password,Birthdate,Created At,Updated At"
    end

    context "exporting Field::Number" do
      it "exports correct data" do
        expect(parsed_data[1][0]).to eq "1"
      end
    end

    context "exporting Field::String" do
      it "exports correct data" do
        expect(parsed_data[1][1]).to eq "John"
      end
    end

    context "exporting Field::String" do
      it "exports correct data" do
        expect(parsed_data[1][2]).to eq "Doe"
      end
    end

    context "exporting Field::HasMany" do
      it "exports correct data" do
        expect(parsed_data[1][3]).to eq "1"
      end
    end

    context "exporting Field::HasOne" do
      it "exports correct data" do
        expect(parsed_data[1][4]).to eq "Cat #1"
      end
    end

    context "exporting Field::Email" do
      it "exports correct data" do
        expect(parsed_data[1][5]).to eq "john@email.com"
      end
    end

    context "exporting Field::Password" do
      it "exports correct data" do
        expect(parsed_data[1][6]).to eq "••••••••••••••••"
      end
    end

    context "exporting Field::Date" do
      it "exports correct data" do
        expect(parsed_data[1][7]).to eq("1990-01-15")
      end
    end

    context "exporting field passing a proc using transform_on_export" do
      it "exports correct data" do
        date = User.first.created_at.strftime("%F")

        expect(parsed_data[1][8]).to eq date
      end
    end

    context "exporting Field::DateTime" do
      it "exports correct data" do
        # Verify the exported datetime format is valid
        exported_datetime = parsed_data[1][9]
        expect(exported_datetime).to match(/\A\w{3}, \d{2} \w{3} \d{4} \d{2}:\d{2}:\d{2} [+-]\d{4}\z/)
      end
    end

    context "exporting Field::BelongsTo" do
      let(:result) { AdministrateExportable::ExporterService.csv(CatDashboard.new, Cat, Cat.all) }

      it "exports correct data" do
        expect(parsed_data[1][0]).to eq "John Doe"
      end
    end

    context "exporting foreign key as a Field::Number" do
      let(:result) { AdministrateExportable::ExporterService.csv(DogDashboard.new, Dog, Dog.all) }

      it "exports header values with sufix '_id'" do
        header = parsed_data[0]

        expect(header[2]).to eq "user_id"
      end

      it "exports correct data" do
        expect(parsed_data[1][2]).to eq "1"
      end
    end

    context "exporting Field::Time" do
      let(:result) { AdministrateExportable::ExporterService.csv(DogDashboard.new, Dog, Dog.all) }

      it "exports correct data" do
        expect(parsed_data[1][4]).to eq "04:05AM"
      end
    end
  end
end
