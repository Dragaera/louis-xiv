class MakerAction < Sequel::Model
  def self.active
    # Todo: Better to do it all in DB, joining tables, filtering by all active columns
    MakerAction.where(active: true).to_a.select { |action| action.is_active? }
  end

  def self.inactive
    # Todo: Better to do it all in DB, joining tables, filtering by all active columns
    MakerAction.all.reject { |action| action.is_active? }
  end

  plugin :validation_helpers

  def validate
    validates_presence [:maker_event_id, :maker_key_id]

    validates_unique [:maker_event_id, :maker_key_id]
  end

  alias_method :active?, :active

  many_to_one :maker_event
  many_to_one :maker_key

  def is_active?
    active && maker_key.active && maker_event.active
  end
end
