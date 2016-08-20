Sequel.migration do
  up do
    create_table :maker_events do
      primary_key :id

      String   :event,  null: false
      Bool     :active, null: false, default: true
      String   :name,   null: false
      DateTime :created_at
      DateTime :updated_at
      DateTime :used_at

      unique :event
    end
  end

  down do
    drop_table :maker_events
  end
end
