
init_typeahead = ->
  $(".player-input").typeahead
    prefetch: "/players.json"
    valueKey: "username"
    ttl: 0

$ init_typeahead
$(document).on("ready", init_typeahead)
