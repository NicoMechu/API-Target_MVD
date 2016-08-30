class NotificationService

  def self.notify_match(match)
    options = 
    {
      send_date: "now",
      # content: { :fr  => "Test", :en  => "Test" },
      data:  match.to_json
    }
    Pushwoosh.notify_devices('congratulations you have a new match! :D', match.user_B.push_tokens, options)
  end
  # handle_asynchronously :notify_match, :priority => 2

  
  def self.send_message(message)
    recipient = message.match_conversation.other_party
    Pusher[recipient.channel_id].trigger('new_message', {
      author: message.user.as_json(only: [:id, :name, :gender]),
      match_conversation_id: message.conversation_id,
      text: message.text,
      time: message.updated_at,
      unread_messages_count: recipient.unread_conversations_count # Current message is not in the database
    })
    Pushwoosh.notify_devices("New message from #{recipient.name}", recipient.push_tokens)
  end
  # handle_asynchronously :send_message, :priority => 1 # The priority for sending message is higer than
                                                      # match notification because the fluentcy of the 
                                                      # app depends on that.
end 
