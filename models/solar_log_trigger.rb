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

  def check(station, chain_sync: false)
    data = station.data_point
    calculator = Dentaku::Calculator.new
    calculator.store(
      power_ac: data.power_ac,
      power_dc: data.power_dc,
      capacity: data.capacity,
      efficiency: data.efficiency,
      alternator_loss: data.alternator_loss,

      voltage_ac: data.voltage_ac,
      voltage_dc: data.voltage_dc,

      consumption_ac: data.consumption_ac,
      usage: data.usage,
      power_available: data.power_available,

      consumption_day: data.consumption_day,
      consumption_yesterday: data.consumption_yesterday,
      consumption_month: data.consumption_month,
      consumption_year: data.consumption_year,
      consumption_total: data.consumption_total,

      production_day: data.production_day,
      production_yesterday: data.production_yesterday,
      production_month: data.production_month,
      production_year: data.production_year,
      production_total: data.production_total
    )

    begin
      now = DateTime.now
      if calculator.evaluate!(condition)
        update(used_at: now)

        maker_actions.each do |action|
          if chain_sync
            action.execute(chain_sync)
          else
            action.async_execute
          end
        end
      end
      update(checked_at: now)
    rescue Dentaku::UnboundVariableError, e
      # @Todo: Store failure somewhere
    end
  end

  def async_check(station = nil)
    if station.nil?
      solar_log_stations_dataset.where(active: true).each do |my_station|
        async_check(my_station)
      end
    else
      Resque.enqueue(Tasks::CheckSolarLogTrigger, id, station.id)
    end
  end
end

# Allow sane deletion of triggers by deleting all entries in many-to-many table.
SolarLogTrigger.plugin :association_dependencies, maker_actions: :nullify, solar_log_stations: :nullify
