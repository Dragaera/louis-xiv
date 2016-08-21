Sequel.migration do
  up do
    create_join_table(:maker_action_id => :maker_actions, :maker_event_id => :maker_events)
    create_join_table(:maker_action_id => :maker_actions, :maker_key_id => :maker_keys)
  end

  down do
    drop_table(:maker_actions_maker_events)
    drop_table(:maker_actions_maker_keys)
  end
end
