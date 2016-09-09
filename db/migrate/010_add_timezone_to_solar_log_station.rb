Sequel.migration do
  up do
    alter_table(:solar_log_stations) do
      add_column :timezone, String, null: false, default: 'UTC'
    end
  end

  down do
    drop_column :timezone
  end
end
