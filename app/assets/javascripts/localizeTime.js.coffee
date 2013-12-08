moment.lang 'en',
  calendar:
      lastDay: '[Yesterday at] LT',
      sameDay: '[Today at] LT',
      nextDay: '[Tomorrow at] LT',
      lastWeek: '[Last] dddd [at] LT',
      nextWeek: 'dddd [at] LT',
      sameElse: 'L'

$(document).on 'ready page:load', ->
  $(".local-time").each (index, element) ->
    # make sure to set the time in utc, then get it in local time
    time = moment.utc(parseInt($(element).text(), 10)*1000).local()

    # use built in calendar formatting; change it by modifying the dictionary above
    $(element).text time.format("h:mm a, MMM D, YYYY")

