json.target do
  json.id         @target.id
  json.latitude   @target.lat
  json.longitude  @target.lng
  json.radius     @target.radius
  json.title      @target.title
  json.topic      @target.topic
end

json.matches @matches, partial: 'api/v1/match_conversations/match', as: :match 
