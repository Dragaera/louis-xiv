module Tasks
  class UpdateStationData
    @queue = :tasks

    def self.perform(station_id)
      station = SolarLogStation[station_id]
      if station.nil?
        raise KeyError, "No SolarLogStation with id '#{ station_id.inspect }' found"
      end

      station.update_data
    end
  end

  class UpdateAllStations
    @queue = :tasks

    def self.perform
      logger.info 'Scheduling updates of all active stations'
      SolarLogStation::active.each do |station|
        station.async_update_data
      end
    end
  end
end
