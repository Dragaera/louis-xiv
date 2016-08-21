Sequel.migration do
  up do
    create_table :maker_actions do
      primary_key :id

      Bool     :active, null: false, default: true
      String   :name,   null: false
      DateTime :created_at
      DateTime :updated_at
      DateTime :used_at
    end
  end

  down do
    drop_table :maker_actions
  end
end
