json.match_id     @match.id
json.topic        @match.topic.id
json.user         @match.other_party(current_user)
json.title        @match.title(current_user)
json.channel_id   @match.channel_id
json.unread       @match.unread(current_user).count
json.last_message @match.messages.lastOne
json.active       @match.active?


