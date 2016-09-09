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
  many_to_one  :ssh_gateway,        delay_pks: true, class: :SSHGateway

  def data_point
    # TODO: Might be better to keep an FK pointing at most recent data point
    solar_log_data_points_dataset.order(Sequel.desc(:id)).first
  end

  def async_update_data
    logger.info "Scheduling update of data of station '#{ name }'"
    Resque.enqueue(Tasks::UpdateStationData, id)
  end

  def update_data
    logger.info "Updating data of station '#{ name }'"

    # TODO: Timezone should come from SolarLogStation
    opts = { timezone: '+0200' }
    if ssh_gateway
      logger.info "Tunneling request via gateway '#{ ssh_gateway.name }'"
      opts[:ssh_gateway] = ssh_gateway.ssh_gateway
    end
    s = Sunscout::SolarLog::SolarLog.new(http_url, opts)
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
    now = DateTime.now
    update(checked_at: now)
    if ssh_gateway
      ssh_gateway.update(used_at: now)
      ssh_gateway.ssh_user.update(used_at: now)
    end

    logger.info 'Successfully updated data'

    solar_log_triggers_dataset.where(active: true).each do |trigger|
      trigger.async_check(self)
    end
  rescue StandardError => e
    # Not pretty... But there's a whole slew of possible errors.
    logger.error "Exception while updating station data: #{ e.message }"
    raise
  end

  def connection_mode
    if ssh_gateway
      :ssh_gateway
    else
      :direct
    end
  end

  def calculator
    if data_point.nil?
      raise ArgumentError, "Station '#{ name }' has no data points"
    end

    calculator = Dentaku::Calculator.new
    calculator.store(
      power_ac:        data_point.power_ac,
      power_dc:        data_point.power_dc,
      power_max:       data_point.power_max,
      capacity:        data_point.capacity,
      efficiency:      data_point.efficiency,
      alternator_loss: data_point.alternator_loss,

      voltage_ac: data_point.voltage_ac,
      voltage_dc: data_point.voltage_dc,

      consumption_ac:  data_point.consumption_ac,
      usage:           data_point.usage,
      power_available: data_point.power_available,

      consumption_day:       data_point.consumption_day,
      consumption_yesterday: data_point.consumption_yesterday,
      consumption_month:     data_point.consumption_month,
      consumption_year:      data_point.consumption_year,
      consumption_total:     data_point.consumption_total,

      production_day:       data_point.production_day,
      production_yesterday: data_point.production_yesterday,
      production_month:     data_point.production_month,
      production_year:      data_point.production_year,
      production_total:     data_point.production_total
    )

    calculator
  end
end

# Allow sane deletion of stations by deleting all entries in many-to-many table.
SolarLogStation.plugin :association_dependencies, solar_log_triggers: :nullify
