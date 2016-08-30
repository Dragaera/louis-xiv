module Tasks
  class UpdateSolarLogStationData
    @queue = :tasks

    def self.perform(station_id)
      station = SolarLogStation[station_id]

      station.update_data
    end
  end

  class UpdateSolarLogStations
    @queue = :tasks

    def self.perform
      SolarLogStation.active.each do |station|
        station.async_update_data
      end
    end
  end
end
