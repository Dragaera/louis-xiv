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

  many_to_many :maker_actions, delay_pks: true, join_table: :solar_log_triggers_actions

  def active_maker_actions
    maker_actions_dataset.where(active: true)
  end

  def inactive_maker_actions
    maker_actions_dataset.where(active: false)
  end
end

# Allow sane deletion of triggers by deleting all entries in many-to-many table.
SolarLogTrigger.plugin :association_dependencies, maker_actions: :nullify
