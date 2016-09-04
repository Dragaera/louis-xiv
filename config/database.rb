# Add association_pks method to *_to_many associations
Sequel::Model.plugin :association_pks
# Add #active? for model with #active column
Sequel::Model.plugin :boolean_readers
# Allow adding associations to unsaved objects by delaying save operation.
Sequel::Model.plugin :delay_add_association
Sequel::Model.plugin :schema
# Automated created at / updated at timestamps
Sequel::Model.plugin :timestamps

Sequel::Model.raise_on_save_failure = true

db_con  = ENV.fetch('DB_CON', "sqlite://db/louis_xiv_#{ Padrino.env }.db")
db_user = ENV['DB_USER']
db_pass = ENV['DB_PASS']

opts = { loggers: [logger] }
if db_user && db_pass
  opts[:user] = db_user
  opts[:password] = db_pass
end

Sequel::Model.db = 
  case Padrino.env
  when :development then
    Sequel.connect(db_con, opts)
  when :production  then
    Sequel.connect(db_con, opts)
  when :test        then
    Sequel.connect(db_con, opts)
  end
