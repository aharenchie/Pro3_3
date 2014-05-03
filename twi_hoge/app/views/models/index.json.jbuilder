json.array!(@models) do |model|
  json.extract! model, :id, :userid, :tweetid
  json.url model_url(model, format: :json)
end
