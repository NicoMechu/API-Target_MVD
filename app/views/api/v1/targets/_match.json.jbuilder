json.match_id   match.id
json.topic      match.topic.id
if match.user_A.id == @target.user_id?
  json.user     match.user_B.id
else
  json.user     match.user_A.id
end
