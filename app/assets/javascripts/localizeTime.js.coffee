$(document).on 'ready page:load', ->
  $(".local-time").each (index, element) ->
    # make sure to set the time in utc, then get it in local time
    time = moment.utc(parseInt($(element).text(), 10)*1000).local()
    $(element).text time.format("h:mm a, MMM D, YYYY")

