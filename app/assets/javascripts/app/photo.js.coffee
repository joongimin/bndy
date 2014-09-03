class Photo
  set_position: (index) ->
    document.body.scrollLeft = (index - 1) * window.innerWidth;

  center_align: ->
    viewport_height = window.innerHeight
    for i in [1..26]
      $page = $("#page-" + i)
      page_hight = $page.height()
      if viewport_height > page_hight
        $page.css('margin-top',((viewport_height - page_hight) * 0.5) + 'px');

app.photo = new Photo

window.onload = ->
  $photos = $("#photos")
  if $photos.length > 0
    $("#photo-close").click ->
      window.history.back()
    app.photo.center_align()
    app.photo.set_position($photos.data("index"))
    $photos.removeClass("hidden")