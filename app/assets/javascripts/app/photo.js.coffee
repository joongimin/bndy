class Photo
  index: ->
    $(document).on "page:loaded", (e) ->
      $("#photo-index-value").text($(".page-3").data("photo-index"))
      for i in [1...5]
        $(".page-" + i).find("img.without-margin").each ->
          app.photo.center_align($(this))

    $(window).load ->
      $("body").removeClass("loading")
      $("img.without-url").each ->
        $photo = $(this)
        $photo.attr("src", $photo.data("url")).removeClass("without-url")

  set_position: (index) ->
    document.body.scrollLeft = (index - 1) * window.innerWidth;

  center_align: ($photo) ->
    app.photo.onload $photo, ->
      photo_height = $photo.height()
      if window.innerHeight > photo_height
        $photo.css(marginTop: (window.innerHeight - photo_height) * 0.5).removeClass("without-margin")

  onload: ($photo, callback) ->
    if $photo[0].complete
      callback()
    else
      interval_id = null
      loaded = false
      finished = ->
        if !loaded
          loaded = true
          callback()
          clearInterval(interval_id)
          interval_id = null

      interval_id = setInterval (->
        if $photo[0].complete
          finished()
      ), 400

      $photo.one "load", ->
        finished()

      $photo.one "error", ->
        finished()

app.photo = new Photo

$("#photo-close").click ->
  window.history.back()