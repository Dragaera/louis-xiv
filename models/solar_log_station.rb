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
    logger.info "Updating data of station '#{ name }'"

    # @Todo: Timezone should come from SolarLogStation
    s = Sunscout::SolarLog::SolarLog.new(http_url, timezone: '+0200')
    data_point = SolarLogDataPoint.new(
      power_ac:        s.power_ac,
      power_dc:        s.power_dc,
      power_max:       s.power_total,
      capacity:        s.capacity,
      efficiency:      s.efficiency,
      alternator_loss: s.alternator_loss,

      voltage_ac: s.voltage_ac,
      voltage_dc: s.voltage_dc,

      consumption_ac:        s.consumption_ac,
      usage:                 s.usage,
      power_available:       s.power_available,

      consumption_day:       s.consumption_day,
      consumption_yesterday: s.consumption_yesterday,
      consumption_month:     s.consumption_month,
      consumption_year:      s.consumption_year,
      consumption_total:     s.consumption_total,

      production_day:       s.yield_day,
      production_yesterday: s.yield_yesterday,
      production_month:     s.yield_month,
      production_year:      s.yield_year,
      production_total:     s.yield_total,

      timestamp: s.time
    )
    add_solar_log_data_point(data_point)
    update(checked_at: DateTime.now)

    logger.info "Successfully updated data"
  rescue StandardError => e
    # Not pretty... But there's a whole slew of possible errors.
    logger.error "Exception while updating station data: #{ e.message }"
    raise
  end
end

# Allow sane deletion of stations by deleting all entries in many-to-many table.
SolarLogStation.plugin :association_dependencies, solar_log_triggers: :nullify
