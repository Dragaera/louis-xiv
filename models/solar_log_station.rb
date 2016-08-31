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
    # @Todo: Might be better to keep an FK pointing at most recent data point
    solar_log_data_points_dataset.order(Sequel.desc(:id)).first
  end

  def async_update_data
    logger.info "Scheduling update of data of station '#{ name }'"
    Resque.enqueue(Tasks::UpdateStationData, id)
  end

  def update_data
    Tasks::UpdateStationData.perform(id)
  end
end

# Allow sane deletion of stations by deleting all entries in many-to-many table.
SolarLogStation.plugin :association_dependencies, solar_log_triggers: :nullify
