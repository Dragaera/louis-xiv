Sequel.migration do
  up do
    alter_table :maker_actions do
      add_column :used_at, DateTime
      add_column :created_at, DateTime
      add_column :updated_at, DateTime
    end

    alter_table :maker_events do
      add_column :used_at, DateTime
      add_column :created_at, DateTime
      add_column :updated_at, DateTime
    end

    alter_table :maker_keys do
      add_column :used_at, DateTime
      add_column :created_at, DateTime
      add_column :updated_at, DateTime
    end
  end

  down do
    alter_table :maker_actions do
      drop_column :used_at
      drop_column :created_at
      drop_column :updated_at
    end

    alter_table :maker_events do
      drop_column :used_at
      drop_column :created_at
      drop_column :updated_at
    end

    alter_table :maker_keys do
      drop_column :used_at
      drop_column :created_at
      drop_column :updated_at
    end
  end
end
