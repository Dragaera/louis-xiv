require 'sunscout'

class SolarLogDataPoint < Sequel::Model
  many_to_one :solar_log_station

  def update_data
    s = Sunscout::SolarLog::SolarLog.new(solar_log_station.http_url)

    set(
      power_ac: s.power_ac,
      power_dc: s.power_dc,

      power_total: s.power_total,

      voltage_ac: s.voltage_ac,
      voltage_dc: s.voltage_dc,

      consumption_ac: s.consumption_ac,
      consumption_day: s.consumption_day,
      consumption_yesterday: s.consumption_yesterday,
      consumption_month: s.consumption_month,
      consumption_year: s.consumption_year,
      consumption_total: s.consumption_total,

      yield_day: s.yield_day,
      yield_yesterday: s.yield_yesterday,
      yield_month: s.yield_month,
      yield_year: s.yield_year,
      yield_total: s.yield_total,

      time: s.time
    )
    save
  end
end
