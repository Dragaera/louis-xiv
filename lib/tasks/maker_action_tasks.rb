module Tasks
  class CallMakerEvent
    URI = 'https://maker.ifttt.com/trigger/%s/with/key/%s'

    @queue = :tasks

    def self.perform(event_id, key_id)
      event = MakerEvent[event_id]

      if event.nil?
        raise KeyError, "No MakerEvent with id '#{ event_id.inspect }'"
      end

      key = MakerKey[key_id]
      raise KeyError, "No MakerKey with id '#{ key_id.inspect }'" if key.nil?

      logger.info "Sending '#{ event.name }' (#{ event.event }) to key '#{ key.name }'"

      uri = URI % [event.event, key.key]
      logger.debug "POSTing to #{ uri }"

      # @Todo: Error handling / logging
      response = HTTParty.post(uri)
      logger.debug "Response code: #{ response.code }"
      logger.debug "Response body: #{ response.body }"
      logger.debug "Response message: #{ response.message }"
      logger.debug "Response headers: #{ response.headers.inspect }"

      now = DateTime.now
      key.update(used_at: now)
      event.update(used_at: now)
    end
  end
end
