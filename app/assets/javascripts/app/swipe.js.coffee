class Swipe
  constructor: ->
    @touch = {
      state: 0,
    }

    @default_page_id = "page-greeting"
    @enable_hash = $("body").hasClass("home")
    @main = document.getElementById("main")
    @$main = $(@main)
    @page_container = document.getElementById("page-container")
    @$page_container = $(@page_container)
    @total_pages = @$page_container.data("total-pages")
    @page_scale = @$page_container.data("page-scale") || 1
    @max_swipe = @$main.width() * @page_scale

    @main.addEventListener "touchstart", (e) => @touchstart(e)
    @main.addEventListener "touchmove", (e) => @touchmove(e)
    @main.addEventListener "touchend", (e) => @touchend(e)
    @main.addEventListener "touchcancel", (e) => @touchend(e)

    $(document).on "page:loaded", (e) => @pageload(e)

    if @enable_hash && window.location.hash
      @goto(window.location.hash.substring(1), true)
    else
      $(document).ready ->
        $(document).trigger("page:loaded")

  pageload: (e) ->
    $page = $(".page-3")
    if @enable_hash
      page_id = $page.attr("id")
      if page_id == @default_page_id
        window.location.hash = ""
      else
        window.location.hash = page_id.substring(5)
    @$main.height($page.height() + 10)

  touchstart: (e) ->
    if e.touches.length == 1
      touch = e.touches[0]
      @touch.state = 1
      @touch.x = touch.screenX
      @touch.y = touch.screenY

  touchmove: (e) ->
    if @touch.state == 1
      touch = e.touches[0]
      x = touch.screenX - @touch.x
      y = touch.screenY - @touch.y
      if Math.abs(y) < Math.abs(x)
        threshold = 20
        if x > threshold || -threshold > x
          @touch.state = 2
          @touch.x = touch.screenX
          @page_container.style["pointer-events"] = "none"
        e.preventDefault()
        e.stopPropagation()
      else
        @touch.state = 3

    if @touch.state == 2
      touch = e.touches[0]
      x = touch.screenX - @touch.x
      if x < -@max_swipe
        x = -@max_swipe
      else if x > @max_swipe
        x = @max_swipe
      @page_container.style["-webkit-transform"] = "translate3d(" + x + "px, 0, 0)"

      e.preventDefault()
      e.stopPropagation()

  touchend: (e) ->
    if @touch.state == 2
      touch = e.changedTouches[0]
      @page_container.style["pointer-events"] = "auto"
      x = touch.screenX - @touch.x
      if x > @max_swipe * 0.2
        @swipe(1)
      else if x < @max_swipe * -0.2
        @swipe(-1)
      else
        @swipe(0)
        @page_container.style["-webkit-transform"] = "translate3d(0, 0, 0)"
        setTimeout (=>
          @$page_container.removeClass("animating")
          @page_container.style["-webkit-transform"] = "translate3d(0, 0, 0)"
          ), 200
    @touch.state = 0

  swipe: (offset, instant) ->
    return if offset == 0
    finalize = =>
      self = this
      $(".page").each ->
        $page = $(this)
        old_page = $(this).data("page")
        new_page = old_page + offset
        if new_page > self.total_pages
          new_page -= self.total_pages
        else if new_page <= 0
          new_page += self.total_pages
        $page.data("page", new_page).removeClass("page-" + old_page).addClass("page-" + new_page)
      $(document).trigger("page:loaded")

    if instant
      finalize()
    else
      @$page_container.addClass("animating")
      @page_container.style["-webkit-transform"] = "translate3d(" + (100 * @page_scale * offset) + "%, 0, 0)"
      setTimeout (=>
        @$page_container.removeClass("animating")
        @page_container.style["-webkit-transform"] = "translate3d(0, 0, 0)"
        finalize()
        ), 200

  goto: (page_name, instant) ->
    @swipe(3 - $("#page-" + page_name).data("page"), instant)


app.swipe = new Swipe

$(".link-swipe").on "click", ->
  app.swipe.goto($(this).data("target"))