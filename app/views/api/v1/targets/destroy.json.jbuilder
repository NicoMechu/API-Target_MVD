json.target do
  json.id         @target.id
  json.latitude   @target.lat
  json.longitude  @target.lng
  json.radius     @target.radius
  json.topic      @target.topic.label
end
