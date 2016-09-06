class NotificationService 
  class << self
    def notify_match(match)
      options = 
      {
        send_date: "now",
        # content: { :fr  => "Test", :en  => "Test" },
        data:  match.to_json
      }
      Pushwoosh.notify_devices('Congratulations you have a new match! :D', match.user_b.push_tokens, options)
    end
    # handle_asynchronously :notify_match, priority: 2

    def send_message(message)
      match = message.match_conversation
      Pusher[match.channel_id].trigger('new_message', {
        author: message.user.as_json(only: [:id, :name, :gender]),
        match_conversation_id: match.id,
        text: message.text,
        time: message.updated_at
      })
      Pushwoosh.notify_devices("New message from #{message.user.name}", message.receiver.push_tokens)
    end
    # handle_asynchronously :send_message, priority: 1 # The priority for sending message is higer than
                                                     # match notification because the fluentcy of the 
                                                     # app depends on that.
  end 
end 
