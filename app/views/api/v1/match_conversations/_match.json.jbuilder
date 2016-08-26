json.match_id   match.id
json.topic      match.topic.id
if match.user_A.id != current_user.id?
  json.user     match.user_A.id
else
  json.user     match.user_B.id
end
