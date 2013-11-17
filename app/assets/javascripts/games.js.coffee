$ ->
  $(".player-input").typeahead
    prefetch: "/players.json"
    valueKey: "username"
    ttl: 0

