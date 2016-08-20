Sequel.migration do
  up do
    create_table :maker_keys do
      primary_key :id

      String   :key,    null: false
      Bool     :active, null: false, default: true
      String   :name,   null: false
      DateTime :created_at
      DateTime :updated_at
      DateTime :used_at

      unique :key
    end
  end

  down do
    drop_table :maker_keys
  end
end
