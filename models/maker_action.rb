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

  many_to_many :maker_events
  many_to_many :maker_keys

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
