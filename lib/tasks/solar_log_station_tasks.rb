module Tasks
  class UpdateStationData
    @queue = :tasks

    def self.perform(station_id)
      station = SolarLogStation[station_id]
      raise KeyError, "No SolarLogStation with id '#{ station_id.inspect }' found" if station.nil?

      logger.info "Updating data of station '#{ station.name }'"

      # @Todo: Timezone should come from SolarLogStation
      s = Sunscout::SolarLog::SolarLog.new(station.http_url, timezone: '+0200')
      data_point = SolarLogDataPoint.new(
        power_ac:        s.power_ac,
        power_dc:        s.power_dc,
        power_max:       s.power_total,
        capacity:        s.capacity,
        efficiency:      s.efficiency,
        alternator_loss: s.alternator_loss,

        voltage_ac: s.voltage_ac,
        voltage_dc: s.voltage_dc,

        consumption_ac:        s.consumption_ac,
        usage:                 s.usage,
        power_available:       s.power_available,

        consumption_day:       s.consumption_day,
        consumption_yesterday: s.consumption_yesterday,
        consumption_month:     s.consumption_month,
        consumption_year:      s.consumption_year,
        consumption_total:     s.consumption_total,

        production_day:       s.yield_day,
        production_yesterday: s.yield_yesterday,
        production_month:     s.yield_month,
        production_year:      s.yield_year,
        production_total:     s.yield_total,

        timestamp: s.time
      )
      station.add_solar_log_data_point(data_point)
      station.update(checked_at: DateTime.now)

      logger.info "Successfully updated data"
    rescue StandardError => e
      # Not pretty... But there's a whole slew of possible errors.
      logger.error "Exception while updating station data: #{ e.message }"
      raise
    end
  end

  class UpdateAllStations
    @queue = :tasks

    def self.perform
      logger.info "Scheduling updates of all active stations"
      SolarLogStation::active.each do |station|
        station.async_update_data
      end
    end
  end
end
