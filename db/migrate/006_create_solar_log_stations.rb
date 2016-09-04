Sequel.migration do
  up do
    create_table :solar_log_stations do
      primary_key :id

      Bool     :active,     null: false, default: true
      String   :name,       null: false
      String   :http_url,   null: false
      DateTime :checked_at
      DateTime :created_at
      DateTime :updated_at
    end

    create_table :solar_log_stations_solar_log_triggers do
      primary_key :id

      foreign_key :solar_log_station_id, :solar_log_stations, null: false
      foreign_key :solar_log_trigger_id, :solar_log_triggers, null: false

      # Default index name would be too long for MySQL, which imposes a 64-char 
      # limit on identifiers.
      index [:solar_log_station_id, :solar_log_trigger_id],
            unique: true,
            name: 'solar_log_stations_triggers_station_trigger'
      index [:solar_log_trigger_id, :solar_log_station_id],
            unique: true,
            name: 'solar_log-stations_triggers_trigger_station'
    end
  end


  down do
    drop_table :solar_log_stations
    drop_table :solar_log_stations_solar_log_triggers
  end
end
