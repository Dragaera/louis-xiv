require 'spec_helper'

RSpec.describe SolarLogStation do
  let(:station_simple) { create(:solar_log_station,
                                name: 'Simple station') }

  let(:station_inactive) { create(:solar_log_station,
                                  :inactive,
                                  name: 'Inactive station') }

  describe '#save' do
    it 'should set the default value of #active' do
      expect(station_simple).to be_active
    end
  end

  describe '#valid?' do
    it 'should validate presence of #name' do
      station = build(:solar_log_station, :active, name: nil)
      expect(station).to_not be_valid

      station = build(:solar_log_station, :inactive, name: nil)
      expect(station).to_not be_valid

      station = build(:solar_log_station, :active, name: 'Test station')
      expect(station).to be_valid
    end

    it 'should validate presence of #http_url' do
      station = build(:solar_log_station, :active, http_url: nil)
      expect(station).to_not be_valid

      station = build(:solar_log_station, :inactive, http_url: nil)
      expect(station).to_not be_valid

      station = build(:solar_log_station, :active, http_url: 'http://1.internal')
      expect(station).to be_valid
    end
  end

  describe '::active' do
    it 'should return those which are active' do
      expect(SolarLogStation.active).to match_array([station_simple])
    end
  end

  describe '::inactive' do
    it 'should return those which are inactive' do
      expect(SolarLogStation.inactive).to match_array([station_inactive])
    end
  end
end
