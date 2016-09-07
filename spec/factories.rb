FactoryGirl.define do
  to_create(&:save)

  trait :active do
    active true
  end

  trait :inactive do
    active false
  end

  factory :maker_event do
    sequence(:event) { |i| "Event #{ i }" }
  end

  factory :maker_key do
    sequence(:key) { |i| "Key #{ i }" }
  end

  factory :maker_action do
    sequence(:name) { |i| "Maker Action #{ i }" }

    trait :with_maker_keys do
      transient do
        maker_keys_count 1
        inactive_maker_keys_count 0
      end

      # TODO: Should be able to do this with create_list
      # However, need to teach it how to associate keys with actions.
      after(:create) do |action, evaluator|
        evaluator.maker_keys_count.times do
          action.add_maker_key create(:maker_key, :active)
        end

        evaluator.inactive_maker_keys_count.times do
          action.add_maker_key create(:maker_key, :inactive)
        end

        action.save
      end
    end

    trait :with_maker_events do
      transient do
        maker_events_count 1
        inactive_maker_events_count 0
      end

      # TODO: Should be able to do this with create_list
      # However, need to teach it how to associate keys with actions.
      after(:create) do |action, evaluator|
        evaluator.maker_events_count.times do
          action.add_maker_event create(:maker_event, :active)
        end

        evaluator.inactive_maker_events_count.times do
          action.add_maker_event create(:maker_event, :inactive)
        end

        action.save
      end
    end
  end

  factory :solar_log_trigger do
    sequence(:name) { |i| "SolarLog Trigger #{ i }" }
    condition 'false'

    trait :with_maker_actions do
      transient do
        maker_actions_count 1
        inactive_maker_actions_count 0
      end

      after(:create) do |trigger, evaluator|
        evaluator.maker_actions_count.times do
          trigger.add_maker_action create(:maker_action, :active)
        end

        evaluator.inactive_maker_actions_count.times do
          trigger.add_maker_action create(:maker_action, :inactive)
        end
      end
    end

    trait :with_solar_log_stations do
      transient do
        solar_log_stations_count 1
        inactive_solar_log_stations_count 1
      end

      after(:create) do |trigger, evaluator|
        evaluator.solar_log_stations_count.times do
          trigger.add_solar_log_station create(:solar_log_station, :active)
        end

        evaluator.inactive_solar_log_stations_count.times do
          trigger.add_solar_log_station create(:solar_log_station, :inactive)
        end
      end
    end
  end

  factory :solar_log_station do
    sequence(:name) { |i| "SolarLog Station #{ i }" }
    sequence(:http_url) { |i| "http://solarlog-#{ i }.local" }
  end

  factory :ssh_user, class: SSHUser do
    sequence(:user) { |i| "ssh_user_#{ i }" }
    sequence(:password) { |i| "ssh_pass_#{ i }" }
    sequence(:private_key) { |i| "ssh_private_key_#{ i }" }
  end
end
