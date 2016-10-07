json.match_id       @match.id
json.topic          @match.topic.id
json.user           @match.other_party(current_user)
json.last_logout    @last_logout
json.active         @match.active?

