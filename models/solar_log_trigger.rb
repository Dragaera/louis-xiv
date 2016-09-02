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

  many_to_many :maker_actions,
               delay_pks:   true,
               join_table:  :solar_log_triggers_actions

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
      solar_log_stations_dataset.where(active: true).each do |my_station|
        async_check(my_station)
      end
    end
  end

  def check(station = nil)
    if station
      begin
        logger.info "Checking trigger '#{ name }' with data of station '#{ station.name }'"

        calculator = station.calculator

        now = DateTime.now
        update(checked_at: now)
        if calculator.evaluate!(condition)
          logger.info('Trigger condition matched')
          update(used_at: now)

          maker_actions_dataset.where(active: true).each(&:async_execute)
        else
          logger.info('Trigger condition did not match')
        end

      rescue Dentaku::UnboundVariableError, Dentaku::ParseError, RuntimeError => e
        logger.error("Exception while evaluationg condition: #{ e.message }")
        raise
      end
    else
      solar_log_stations.dataset.where(active: true).each do |my_station|
        check(my_station)
      end
    end
  end
end

# Allow sane deletion of triggers by deleting all entries in many-to-many table.
SolarLogTrigger.plugin :association_dependencies, 
                       maker_actions: :nullify, 
                       solar_log_stations: :nullify
