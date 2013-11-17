json.array!(@players) do |player|
  json.username player.username
  json.profile_url player_url(player, format: :json)
end
