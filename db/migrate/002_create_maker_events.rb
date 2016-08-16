Sequel.migration do
  up do
    create_table :maker_events do
      primary_key :id

      String :event,  null: false
      Bool   :active, null: false, default: true

      unique :event
    end
  end

  down do
    drop_table :maker_events
  end
end
