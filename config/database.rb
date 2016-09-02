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

Sequel::Model.db = 
  case Padrino.env
  when :development then
    Sequel.connect('sqlite://db/louis_xiv_development.db', loggers: [logger])
  when :production  then
    Sequel.connect('sqlite://db/louis_xiv_production.db',  loggers: [logger])
  when :test        then
    Sequel.connect('sqlite://db/louis_xiv_test.db',        loggers: [logger])
  end
