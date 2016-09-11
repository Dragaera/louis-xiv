require 'spec_helper'

RSpec.describe SolarLogStation do
  let(:station_simple) do
    create(:solar_log_station, name: 'Simple station')
  end

  let(:station_inactive) do
    create(:solar_log_station, :inactive, name: 'Inactive station')
  end

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

    it 'should validate #timezone being a valid timezone' do
      station = build(:solar_log_station, timezone: 'Foo/Bar')
      expect(station).to_not be_valid

      station = build(:solar_log_station, timezone: 'Europe/London')
      expect(station).to be_valid
    end

    it 'should validate #http_url being a valid URI' do
      station = build(:solar_log_station, http_url: 'http://foo bar')
      expect(station).to_not be_valid

      station = build(:solar_log_station, http_url: 'http://foo.bar:8080/getjp')
      expect(station).to be_valid
    end
  end

  describe '#connection_mode' do
    it 'returns :ssh_gateway if an SSH gateway is defined' do
      # TODO: Allow creation via factory
      user    = create(:ssh_user)
      gateway = create(:ssh_gateway, ssh_user: user)
      station = create(:solar_log_station, ssh_gateway: gateway)
      expect(station.connection_mode).to eq :ssh_gateway
    end

    it 'returns :direct if direct connection is chosen' do
      station = create(:solar_log_station)
      expect(station.connection_mode).to eq :direct
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
