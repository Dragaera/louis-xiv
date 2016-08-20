Sequel.migration do
  up do
    create_table :maker_actions do
      primary_key :id
      foreign_key :maker_key_id,   :maker_keys,   null: false, on_update: :cascade, on_delete: :restrict
      foreign_key :maker_event_id, :maker_events, null: false, on_update: :cascade, on_delete: :restrict

      Bool     :active, null: false, default: true
      String   :name,   null: false
      DateTime :created_at
      DateTime :updated_at
      DateTime :used_at
      
      unique [:maker_key_id, :maker_event_id]
    end
  end

  down do
    drop_table :maker_actions
  end
end
