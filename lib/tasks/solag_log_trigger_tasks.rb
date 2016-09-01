module Tasks
  class CheckTrigger
    @queue = :tasks

    def self.perform(trigger_id, station_id)
      trigger = SolarLogTrigger[trigger_id]
      raise KeyError, "No SolarLogTrigger with id '#{ trigger_id.inspect }'" if trigger.nil?

      station = SolarLogStation[station_id]
      raise KeyError, "No SolarLogStation with id '#{ station_id.inspect }'" if station.nil?

      raise ArgumentError, "Trigger '#{ trigger.name }' has no station '#{ station.name }'" unless trigger.solar_log_station_pks.include? station_id

      trigger.check(station)
    end
  end
end
