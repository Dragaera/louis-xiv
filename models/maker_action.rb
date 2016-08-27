class MakerAction < Sequel::Model
  def self.active
    MakerAction.where(active: true)
  end

  def self.inactive
    MakerAction.where(active: false)
  end

  plugin :validation_helpers

  def validate
    validates_presence [:name]
  end

  alias_method :active?, :active

  # Needed for AssociationPks plugin to work on new objects.
  many_to_many :maker_events,       delay_pks: true
  many_to_many :maker_keys,         delay_pks: true
  many_to_many :solar_log_triggers, delay_pks: true, join_table: :solar_log_triggers_actions

  def active_maker_keys
    maker_keys_dataset.where(active: true).to_a
  end

  def inactive_maker_keys
    maker_keys_dataset.where(active: false).to_a
  end

  def active_maker_events
    maker_events_dataset.where(active: true).to_a
  end

  def inactive_maker_events
    maker_events_dataset.where(active: false).to_a
  end
end

# Allow sane deletion of actions by deleting all entries in many-to-many table.
MakerAction.plugin :association_dependencies, maker_keys: :nullify, maker_events: :nullify
