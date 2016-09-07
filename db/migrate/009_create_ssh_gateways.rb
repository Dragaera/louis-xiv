Sequel.migration do
  up do
    create_table :ssh_gateways do
      primary_key :id
      foreign_key :ssh_user_id, :ssh_users, null: false

      String   :name
      String   :host,   null: false
      Bool     :active, null: false, default: true
      DateTime :used_at
      DateTime :created_at
      DateTime :updated_at
    end

    alter_table :solar_log_stations do
      add_foreign_key :ssh_gateway_id, :ssh_gateways
    end
  end

  down do
    drop_table :ssh_gateways

    alter_table :solar_log_stations do
      drop_foreign_key :ssh_gateway_id
    end
  end
end
