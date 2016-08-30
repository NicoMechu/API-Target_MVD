json.id         @message.id
json.sender     @message.user_id
json.receiver   @match.other_party(current_user).id
json.text       @message.text
