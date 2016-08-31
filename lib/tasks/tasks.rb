module Tasks
  class CheckSolarLogTrigger
    @queue = :tasks

    def self.perform(trigger_id, station_id)
      trigger = SolarLogTrigger[trigger_id]
      station = SolarLogStation[station_id]

      trigger.check(station)
    end
  end

  class ExecuteMakerAction
    @queue = :tasks

    def self.perform(action_id)
      action = MakerAction[action_id]
      action.execute
    end
  end
end
