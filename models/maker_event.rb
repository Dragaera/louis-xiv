class MakerEvent < Sequel::Model
  def self.active
    MakerEvent.where(is_active: true)
  end

  def self.inactive
    MakerEvent.where(is_active: false)
  end

  plugin :validation_helpers

  def validate
    validates_presence [:event]

    validates_unique :event
  end

  alias_method :is_active?, :is_active
end
