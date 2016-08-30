class SolarLogDataPoint < Sequel::Model
  many_to_one :solar_log_station
end
