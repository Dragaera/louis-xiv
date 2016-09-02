module Tasks
  class CheckTrigger
    @queue = :tasks

    def self.perform(trigger_id, station_id)
      trigger = SolarLogTrigger[trigger_id]
      if trigger.nil?
        raise KeyError, "No SolarLogTrigger with id '#{ trigger_id.inspect }'"
      end

      station = SolarLogStation[station_id]
      if station.nil?
        raise KeyError, "No SolarLogStation with id '#{ station_id.inspect }'"
      end

      unless trigger.solar_log_station_pks.include? station_id
        raise ArgumentError, "Trigger '#{ trigger.name }' has no station '#{ station.name }'"
      end

      trigger.check(station)
    end
  end
end
