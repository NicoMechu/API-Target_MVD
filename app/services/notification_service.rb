class NotificationService 
  class << self
    def notify_match(match)
      options = 
      {
        send_date: "now",
        data: {
                id:           match.id,
                topic:        match.topic,
                user:         match.user_a,
                title:        match.title_b,
                channel_id:   match.channel_id,
                unread:       match.unread(match.user_b),
                last_message: match.messages.lastOne
              }
      }
      Pushwoosh.notify_devices('Congratulations you have a new match! :D', match.user_b.push_tokens.pluck(:push_token), options)
    end
    # handle_asynchronously :notify_match, priority: 2

    def send_message(message)
      match = message.match_conversation
      options = 
      {
        send_date: "now",
        data:  message.as_json
      }
      Pusher[match.channel_id].trigger('new_message', message.as_json )
      Pushwoosh.notify_devices("New message from #{message.user.name}", message.receiver.push_tokens.pluck(:push_token), options)
    end
    # handle_asynchronously :send_message, priority: 1 # The priority for sending message is higer than
                                                       # match notification because the fluentcy of the 
                                                       # app depends on that.
  end 
end 
