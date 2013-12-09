# initialize typeahead to put in game participants
$(document).on "ready page:load", ->
  $(".player-input").typeahead
    prefetch: Routes.players_path({format: "json"})
    valueKey: "username"
    ttl: 0

  reloadNotificationCount = ->
    updateNotificationCount = (data) ->
      $(".notification-count").text(data.count)
      if data.count == 0
        $(".game-confirmations").fadeOut()
      else
        $(".game-confirmations").fadeIn()

    confirmations_url = Routes.confirmations_games_path({format: "json"})
    $.get confirmations_url, updateNotificationCount

  if $(".notification-count").length > 0
    setInterval reloadNotificationCount, 5000

  # make game confirmation buttons on games AJAXy
  $(".game-confirmation-button").each (index, el) ->
    $el = $(el)

    $el.click (event) ->
      event.preventDefault() # don't actually follow link
      event.stopPropagation() # stop the rails handler from firing

      $.ajax
        url: $el.attr("href")
        type: $el.attr("data-method")
        dataType: "json"
        success: ->
          $($el.attr("data-hide")).slideUp()
          reloadNotificationCount()
