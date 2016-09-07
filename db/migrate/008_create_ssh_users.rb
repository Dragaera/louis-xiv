Sequel.migration do
  up do
    create_table :ssh_users do
      primary_key :id
      Bool   :active,     null: false, default: true
      String :user,       null: false
      String :password
      String :private_key
      DateTime :used_at
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table :ssh_users
  end
end
