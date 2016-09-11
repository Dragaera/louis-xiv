class MakerKey < Sequel::Model
  def self.active
    MakerKey.where(active: true)
  end

  def self.inactive
    MakerKey.where(active: false)
  end

  def before_validation
    self.name = key if name.nil? || name.empty?
  end

  plugin :validation_helpers

  def validate
    validates_presence [:key, :name]

    validates_unique :key

    validates_max_length 255, [:key, :name]
  end

  alias_method :active?, :active

  many_to_many :maker_actions
end

MakerKey.plugin :association_dependencies, maker_actions: :nullify
