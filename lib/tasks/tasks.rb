module Tasks
  class ExecuteMakerAction
    @queue = :tasks

    def self.perform(action_id)
      action = MakerAction[action_id]
      action.execute
    end
  end
end
