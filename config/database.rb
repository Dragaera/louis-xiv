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

Sequel.extension :named_timezones

timezone_db          = ENV.fetch('TIMEZONE_DATABASE', 'UTC')
timezone_application = ENV.fetch('TIMEZONE_APPLICATION', 'UTC')
timezone_typecast    = ENV.fetch('TIMEZONE_TYPECAST', timezone_application)

# Catching TZInfo::InvalidTimezoneIdentifier / Logging & Reraising leads to the
# exception being hidden behind a "No DB assigned to Sequel::Model", so we'll
# just let it bubble up.
tz_db   = TZInfo::Timezone.get(timezone_db)
tz_app  = TZInfo::Timezone.get(timezone_application)
tz_cast = TZInfo::Timezone.get(timezone_typecast)

logger.info "Database timezone: #{ tz_db }"
logger.info "Application timezone: #{ tz_app }"
logger.info "Typecast timezone: #{ tz_cast }"

Sequel.database_timezone    = tz_db
Sequel.application_timezone = tz_app
Sequel.typecast_timezone    = tz_cast

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
