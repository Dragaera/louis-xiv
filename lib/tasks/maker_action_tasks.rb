module Tasks
  class CallMakerEvent
    URI = "https://maker.ifttt.com/trigger/%s/with/key/%s"

    @queue = :tasks

    def self.perform(event_id, key_id)
      event = MakerEvent[event_id]
      raise KeyError, "No MakerEvent with id '#{ event_id.inspect }'" if event.nil?

      key = MakerKey[key_id]
      raise KeyError, "No MakerKey with id '#{ key_id.inspect }'" if key.nil?

      logger.info "Sending '#{ event.name }' to key '#{ key.name }'"

      uri = URI % [key.key, event.event]

      # @Todo: Error handling / logging
      HTTParty.post(uri)

      now = DateTime.now
      key.update(used_at: now)
      event.update(used_at: now)
    end
  end
end
