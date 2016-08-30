require 'sunscout'

class SolarLogDataPoint < Sequel::Model
  many_to_one :solar_log_station

  def update_data
    s = Sunscout::SolarLog::SolarLog.new(solar_log_station.http_url)

    set(
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
    save
  end
end
