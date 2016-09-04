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
      DateTime :checked_at
    end

    create_table :solar_log_triggers_maker_actions do
      primary_key :id

      foreign_key :solar_log_trigger_id, :solar_log_triggers, null: false
      foreign_key :maker_action_id,      :maker_actions,      null: true

      # Default index name would be too long for MySQL, which imposes a 64-char 
      # limit on identifiers.
      index [:solar_log_trigger_id, :maker_action_id],
            unique: true,
            name:   'solar_log_triggers_maker_actions_trigger_action_index'
      index [:maker_action_id, :solar_log_trigger_id],
            unique: true,
            name:   'solar_log_triggers_maker_actions_action_trigger_index'
    end
  end

  down do
    drop_table :solar_log_triggers
    drop_table :solar_log_triggers_actions
  end
end
