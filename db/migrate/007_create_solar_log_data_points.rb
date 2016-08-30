Sequel.migration do
  up do
    create_table :solar_log_data_points do
      primary_key :id
      foreign_key :solar_log_station_id, :solar_log_stations, null: false, on_update: :cascade, on_delete: :cascade

      Int :power_ac
      Int :power_dc

      Int :power_total

      Int :voltage_ac
      Int :voltage_dc

      Int :consumption_ac

      Int :consumption_day
      Int :consumption_yesterday
      Int :consumption_month
      Int :consumption_total
      Int :consumption_year

      Int :yield_day
      Int :yield_yesterday
      Int :yield_month
      Int :yield_total
      Int :yield_year

      DateTime :time

      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table :solar_log_data_points
  end
end
