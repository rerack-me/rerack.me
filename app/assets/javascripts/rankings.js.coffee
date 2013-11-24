$(document).on "ready page:load", ->
  $(".rankings-link").click (event) ->
    event.preventDefault()
    target_id = $(event.target).attr("href")
    $("html, body").animate({scrollTop: $(target_id).offset().top - 200}, 1000);
    
