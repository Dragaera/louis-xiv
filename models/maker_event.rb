class MakerEvent < Sequel::Model
  def self.active
    MakerEvent.where(active: true)
  end

  def self.inactive
    MakerEvent.where(active: false)
  end

  plugin :validation_helpers

  def validate
    validates_presence [:event]

    validates_unique :event
  end

  alias_method :active?, :active
end
