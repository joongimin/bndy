class Swipe
  constructor: ->
    @total_pages = 4
    @touch = {
      state: 0,
    }

    @main = document.getElementById("main")
    @$main = $(@main)
    @page_container = document.getElementById("page-container")
    @$page_container = $(@page_container)

    @main.addEventListener "touchstart", (e) -> app.swipe.touchstart(e)
    @main.addEventListener "touchmove", (e) -> app.swipe.touchmove(e)
    @main.addEventListener "touchleave", (e) -> app.swipe.touchend(e)
    @main.addEventListener "touchend", (e) -> app.swipe.touchend(e)
    @main.addEventListener "touchcancel", (e) -> app.swipe.touchend(e)

    $(document).on "page:loaded", (e) -> app.swipe.pageload(e)

  pageload: (e) ->
    @$main.height($(".page-1").height() + 10)

  touchstart: (e) ->
    if e.touches.length == 1
      touch = e.touches[0]
      @touch.state = 1
      @touch.x = touch.screenX

  touchmove: (e) ->
    touch = e.touches[0]
    if @touch.state == 1
      x = touch.screenX - @touch.x
      threshold = 20
      if x > threshold || -threshold > x
        @touch.state = 2
        @touch.x = touch.screenX
        @touch.w = @$main.width() * 0.9
        @page_container.style["pointer-events"] = "none"
      else
        e.preventDefault()
        e.stopPropagation()

    if @touch.state == 2
      x = touch.screenX - @touch.x
      if x < -@touch.w
        x = -@touch.w
      else if x > @touch.w
        x = @touch.w
      @page_container.style["-webkit-transform"] = "translate3d(" + x + "px, 0, 0)"

      e.preventDefault()
      e.stopPropagation()

  touchend: (e) ->
    if @touch.state == 2
      touch = e.changedTouches[0]
      @page_container.style["pointer-events"] = "auto"
      x = touch.screenX - @touch.x
      if x > @touch.w * 0.2
        @swipe(1)
      else if x < @touch.w * -0.2
        @swipe(-1)
      else
        @swipe(0)
        @page_container.style["-webkit-transform"] = "translate3d(0, 0, 0)"
        setTimeout (->
          app.swipe.$page_container.removeClass("animating")
          app.swipe.page_container.style["-webkit-transform"] = "translate3d(0, 0, 0)"
          ), 200
    @touch.state = 0

  swipe: (offset) ->
    @$page_container.addClass("animating")
    @page_container.style["-webkit-transform"] = "translate3d(" + (90 * offset) + "%, 0, 0)"
    setTimeout (->
      app.swipe.$page_container.removeClass("animating")
      app.swipe.page_container.style["-webkit-transform"] = "translate3d(0, 0, 0)"
      if offset != 0
        $(".page").each ->
          $page = $(this)
          old_page = $(this).data("page")
          new_page = old_page + offset
          if new_page > app.swipe.total_pages
            new_page -= app.swipe.total_pages
          else if new_page <= 0
            new_page += app.swipe.total_pages
          $page.data("page", new_page).removeClass("page-" + old_page).addClass("page-" + new_page)
        $(document).trigger("page:loaded")
      ), 200

  goto: (page_name) ->
    new_page = $("#page-" + page_name).data("page")
    @swipe(if new_page == @total_pages then 1 else 1 - new_page)


app.swipe = new Swipe
$(document).trigger("page:loaded")

$(".link-swipe").click ->
  app.swipe.goto($(this).data("target"))