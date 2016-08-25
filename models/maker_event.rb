class MakerEvent < Sequel::Model
  def self.active
    MakerEvent.where(active: true)
  end

  def self.inactive
    MakerEvent.where(active: false)
  end

  def before_validation
    self.name = event if name.nil? || name.empty?
  end

  plugin :validation_helpers

  def validate
    validates_presence [:event, :name]

    validates_unique :event
  end

  alias_method :active?, :active

  many_to_many :maker_actions
end

MakerEvent.plugin :association_dependencies, maker_actions: :nullify
