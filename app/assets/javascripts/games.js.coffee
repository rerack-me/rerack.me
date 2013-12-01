# initialize typeahead to put in game participants
$(document).on "ready page:load", ->
  $(".player-input").typeahead
    prefetch: "/players.json"
    valueKey: "username"
    ttl: 0



reloadNotificationCount = ->
  updateNotificationCount = (data) ->
    $(".notification-count").text(data.count)
    if data.count == 0
      $(".confirmations-button").fadeOut()
    else
      $(".confirmations-button").fadeIn()

  $.get "/games/confirmations.json", updateNotificationCount

setInterval reloadNotificationCount, 1000

# make game confirmation buttons on games AJAXy
$(document).on "ready page:load", ->
  $(".game-confirmation-button").each (index, el) ->
    $el = $(el)

    $el.click (event) ->
      event.preventDefault() # don't actually follow link
      event.stopPropagation() # stop the rails handler from firing

      $.post $el.attr("href"), ->
        $($el.attr("data-hide")).fadeOut()
        reloadNotificationCount()
