json.match_id     @match.id
json.topic        @match.topic.id
json.user         @match.other_party(current_user)
json.channel_id   @match.channel_id
json.unreaded     @match.unreaded(current_user).count
json.last_message @match.messages.lastOne


