$(document).on "ready page:load", ->
  tooltip = $("notifications-count").tooltip
    placement: "bottom"
    title: "Games to be Confirmed"
    trigger: "manual"