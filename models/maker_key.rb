class MakerKey < Sequel::Model
  def self.active
    MakerKey.where(is_active: true)
  end

  def self.inactive
    MakerKey.where(is_active: false)
  end

  plugin :validation_helpers

  def validate
    validates_presence [:key]

    validates_unique :key
  end

  alias_method :is_active?, :is_active
end
