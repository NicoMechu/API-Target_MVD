json.id         message.id
json.sender     message.user_id
json.receiver   message.receiver.id
json.text       message.text
json.time do
  json.date do
    json.day      message.updated_at.day
    json.month    message.updated_at.month
    json.year     message.updated_at.year
  end
  json.hour  message.updated_at.hour
  json.min   message.updated_at.min
  json.sec   message.updated_at.sec
end

