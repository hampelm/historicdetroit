require 'rails_helper'

RSpec.describe Building, type: :model do
  let(:building) { FactoryBot.build :building }

  it 'has a valid factory' do
    expect(building).to be_valid
  end

  describe 'coordinate validation' do
    def with_coordinates(lat, lng)
      building.lat = lat
      building.lng = lng
      building.validate
      building
    end

    it 'accepts coordinates in Detroit' do
      expect(with_coordinates(42.3314, -83.0458)).to be_valid
    end

    it 'accepts a building with no coordinates' do
      expect(with_coordinates(nil, nil)).to be_valid
    end

    it 'accepts the outer edges of the valid ranges' do
      expect(with_coordinates(90, -180)).to be_valid
      expect(with_coordinates(-90, -180)).to be_valid
      expect(with_coordinates(90, 180)).to be_valid
    end

    it 'rejects a latitude without a longitude' do
      with_coordinates(42.3314, nil)
      expect(building).not_to be_valid
      expect(building.errors[:base].first).to include('Both latitude and longitude are needed')
    end

    it 'rejects a longitude without a latitude' do
      with_coordinates(nil, -83.0458)
      expect(building).not_to be_valid
      expect(building.errors[:base].first).to include('Both latitude and longitude are needed')
    end

    it 'rejects a latitude outside -90..90 and explains the likely missing decimal point' do
      with_coordinates(423314, -83.0458)
      expect(building).not_to be_valid
      message = building.errors[:base].first
      expect(message).to include('Latitude must be a number between -90 and 90, but it is 423314.0')
      expect(message).to include('decimal point is missing')
    end

    it 'rejects a longitude outside -180..180 and explains the likely missing decimal point' do
      with_coordinates(42.341261, -83113333)
      expect(building).not_to be_valid
      message = building.errors[:base].first
      expect(message).to include('Longitude must be a number between -180 and 180, but it is -83113333.0')
      expect(message).to include('decimal point is missing')
    end

    it 'shows huge values as plain numbers, not scientific notation' do
      with_coordinates(42.34228653644331, BigDecimal('-8306113699523989.0'))
      expect(building.errors[:base].first).to include('-8306113699523989.0')
      expect(building.errors[:base].first).not_to match(/\de\d/)
    end

    it 'reports both problems when both coordinates are out of range' do
      with_coordinates(423314, -830458)
      expect(building.errors[:base].size).to eq 2
    end

    it 'rejects coordinates that look swapped' do
      with_coordinates(-83.0458, 42.3314)
      expect(building).not_to be_valid
      expect(building.errors[:base].first).to include('Latitude and longitude look swapped (latitude -83.0458, longitude 42.3314)')
    end

    it 'does not save a building with invalid coordinates' do
      with_coordinates(42.341261, -83113333)
      expect(building.save).to be false
    end
  end
end
