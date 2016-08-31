module Tasks
  # Update data of one SolarLogStation object.
  class UpdateSolarLogStationData
    @queue = :tasks

    def self.perform(station_id)
      station = SolarLogStation[station_id]

      station.update_data
    end
  end

  # Schedule updates for all active SolarLogStation objects.
  class UpdateSolarLogStations
    @queue = :tasks

    def self.perform
      SolarLogStation.active.each do |station|
        station.async_update_data
      end
    end
  end

  class CheckSolarLogTrigger
    @queue = :tasks

    def self.perform(trigger_id, station_id)
      trigger = SolarLogTrigger[trigger_id]
      station = SolarLogStation[station_id]

      trigger.check(station)
    end
  end
end
