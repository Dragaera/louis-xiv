Sequel.migration do
  up do
    create_table :maker_keys do
      primary_key :id

      String :key,       null: false
      Bool   :is_active, null: false, default: true

      unique :key
    end
  end

  down do
    drop_table :maker_keys
  end
end
