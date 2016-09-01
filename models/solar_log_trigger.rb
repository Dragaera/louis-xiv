class SolarLogTrigger < Sequel::Model
  def self.active
    SolarLogTrigger.where(active: true)
  end

  def self.inactive
    SolarLogTrigger.where(active: false)
  end

  plugin :validation_helpers

  def validate
    validates_presence [:name, :condition]
  end

  many_to_many :maker_actions,      delay_pks: true, join_table: :solar_log_triggers_actions
  many_to_many :solar_log_stations, delay_pks: true

  def active_maker_actions
    maker_actions_dataset.where(active: true)
  end

  def inactive_maker_actions
    maker_actions_dataset.where(active: false)
  end

  def async_check(station = nil)
    if station
      logger.info "Scheduling check of trigger '#{ name }' with data of station '#{ station.name }'"
      Resque.enqueue(Tasks::CheckTrigger, id, station.id)
    else
      solar_log_stations_dataset.where(active: true).each { |my_station| async_check(my_station) }
    end
  end

  def check(station = nil)
    if station
      begin
        logger.info "Checking trigger '#{ name }' with data of station '#{ station.name }'"

        data_point = station.data_point
        raise ArgumentError, "Station '#{ station.name }' has no data points" if data_point.nil?

        calculator = Dentaku::Calculator.new
        calculator.store(
          power_ac:        data_point.power_ac,
          power_dc:        data_point.power_dc,
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

        now = DateTime.now
        update(checked_at: now)
        if calculator.evaluate!(condition)
          logger.info('Trigger condition matched')
          update(used_at: now)
          # LEFTOFF:
          # - Trigger trigger
        else
          logger.info('Trigger condition did not match')
        end

      rescue Dentaku::UnboundVariableError, Dentaku::ParserError, RuntimeError => e
        logger.error("Exception while evaluationg condition: #{ e.message }")
        raise
      end
    else
      solar_log_stations.dataset.where(active: true).each { |my_station| check(my_station) }
    end
  end

end

# Allow sane deletion of triggers by deleting all entries in many-to-many table.
SolarLogTrigger.plugin :association_dependencies, maker_actions: :nullify, solar_log_stations: :nullify
