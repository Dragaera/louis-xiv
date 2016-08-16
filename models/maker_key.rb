class MakerKey < Sequel::Model
  def self.active
    MakerKey.where(active: true)
  end

  def self.inactive
    MakerKey.where(active: false)
  end

  plugin :validation_helpers

  def validate
    validates_presence [:key]

    validates_unique :key
  end

  alias_method :active?, :active
end
