
init_typeahead = ->
  $(".player-input").typeahead
    prefetch: "/players.json"
    valueKey: "username"
    ttl: 0

$(document).on("ready page:load", init_typeahead)
