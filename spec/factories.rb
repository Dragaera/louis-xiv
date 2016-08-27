FactoryGirl.define do
  to_create { |instance| instance.save }

  trait :active do
    active true
  end

  trait :inactive do
    active false
  end

  factory :maker_event do
    event "Test event"
  end
end
