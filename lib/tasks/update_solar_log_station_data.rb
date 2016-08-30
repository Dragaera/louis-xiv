module Tasks
  class UpdateSolarLogStationData
    @queue = :tasks

    def self.perform(station_id)
      station = SolarLogStation[station_id]

      station.update_data
    end
  end
end
