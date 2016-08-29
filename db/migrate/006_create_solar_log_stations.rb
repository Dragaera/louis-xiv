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

    create_join_table(:solar_log_station_id => :solar_log_stations, :solar_log_trigger_id => :solar_log_triggers)
  end


  down do
    drop_table :solar_log_stations
    drop_table :solar_log_stations_solar_log_triggers
  end
end
