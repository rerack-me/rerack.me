<<<<<<< HEAD
$(document).on 'page:change', ->
=======
$(document).on 'ready page:load', ->
>>>>>>> 2015b24ef7b6c6fc3496d9b2e957bc4d30495f38
  if window._gaq?
    _gaq.push ['_trackPageview']
  else if window.pageTracker?
    pageTracker._trackPageview()
