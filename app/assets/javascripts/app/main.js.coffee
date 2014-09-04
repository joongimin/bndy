$(".link-submit").click ->
  $(this).closest("form").submit()

$(document).ready ->
  $("img.smooth").each ->
    $img = $(this)
    app.image.on_load $img, ->
      $img.addClass("loaded")
      setTimeout (-> $img.removeClass("smooth")), 200