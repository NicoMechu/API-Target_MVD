class NotificationService
  def self.send_message(user, message, data)
    options = 
    {
      send_date: "now",
      # content: { :fr  => "Test", :en  => "Test" },
      data:  data
    }
    Pushwoosh.notify_devices(message, user.push_tokens, options)
  end
end 
