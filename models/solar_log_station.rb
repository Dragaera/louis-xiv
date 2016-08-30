class SolarLogStation < Sequel::Model
  def self.active
    SolarLogStation.where(active: true)
  end

  def self.inactive
    SolarLogStation.where(active: false)
  end

  plugin :validation_helpers

  def validate
    validates_presence [:name, :http_url]
  end

  many_to_many :solar_log_triggers, delay_pks: true
  one_to_many  :solar_log_data_points
end

# Allow sane deletion of stations by deleting all entries in many-to-many table.
SolarLogStation.plugin :association_dependencies, solar_log_triggers: :nullify
