Sequel.migration do
  up do
    create_table :solar_log_triggers do
      primary_key :id

      Bool     :active,    null: false, default: true
      String   :name,      null: false
      String   :condition, null: false, size: 10_000
      DateTime :created_at
      DateTime :updated_at
      DateTime :used_at
    end

    create_table :solar_log_triggers_actions do
      primary_key :id

      foreign_key :solar_log_trigger_id, :solar_log_triggers, null: false
      foreign_key :maker_action_id,      :maker_actions,      null: true

      index [:solar_log_trigger_id, :maker_action_id], unique: true
      index [:maker_action_id, :solar_log_trigger_id], unique: true
    end
  end

  down do
    drop_table :solar_log_triggers
    drop_table :solar_log_triggers_actions
  end
end
