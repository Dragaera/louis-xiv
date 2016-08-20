Sequel::Model.plugin :boolean_readers
Sequel::Model.plugin :schema
Sequel::Model.plugin :timestamps

Sequel::Model.raise_on_save_failure = true

Sequel::Model.db = case Padrino.env
  when :development then Sequel.connect("sqlite://db/louis_xiv_development.db", :loggers => [logger])
  when :production  then Sequel.connect("sqlite://db/louis_xiv_production.db",  :loggers => [logger])
  when :test        then Sequel.connect("sqlite://db/louis_xiv_test.db",        :loggers => [logger])
end
