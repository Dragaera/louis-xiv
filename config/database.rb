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

db_adapter  = ENV.fetch('DB_ADAPTER', 'sqlite')
db_host     = ENV['DB_HOST']
db_database = ENV.fetch('DB_DATABASE', "db/louis_xiv_#{ Padrino.env }.db")
db_user     = ENV['DB_USER']
db_pass     = ENV['DB_PASS']

opts            = { loggers: [logger] }
opts[:adapter]  = db_adapter
opts[:host]     = db_host if db_host
opts[:database] = db_database if db_database
opts[:user]     = db_user if db_user
opts[:password] = db_pass if db_pass
opts[:test]     = true

Sequel::Model.db = 
  case Padrino.env
  when :development then
    Sequel.connect(opts)
  when :production  then
    Sequel.connect(opts)
  when :test        then
    Sequel.connect(opts)
  end
