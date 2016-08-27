class SolarLogTrigger < Sequel::Model
  plugin :validation_helpers

  def validate
    validates_presence [:name, :condition]
  end

  many_to_many :maker_actions, delay_pks: true, join_table: :solar_log_triggers_actions
end

