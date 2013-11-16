# populate_player_input_typeahead = () ->
# $(".player-input").typeahead "destroy"

$(document).ready () ->
  $(".player-input").typeahead
    prefetch: '/players.json'
    ttl: 0
console.log(5)