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

  def data_point
    if solar_log_data_points.count > 0
      solar_log_data_points.first
    else
      add_solar_log_data_point(SolarLogDataPoint.new)
    end
  end

  def update_data(chain_sync: false)
    data_point.update_data
    update(checked_at: DateTime.now)

    solar_log_triggers_dataset.where(active: true).each do |trigger|
      if chain_sync
        trigger.check(self, chain_sync)
      else
        trigger.async_check(self)
      end
    end
  end

  def async_update_data
    Resque.enqueue(Tasks::UpdateSolarLogStationData, id)
  end
end

# Allow sane deletion of stations by deleting all entries in many-to-many table.
SolarLogStation.plugin :association_dependencies, solar_log_triggers: :nullify
