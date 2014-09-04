class Image
  on_load: ($target, callback) ->
    if $target.length
      if $target[0].complete
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
          if $target[0].complete
            finished()
        ), 400

        $target.one "load", ->
          finished()

        $target.one "error", ->
          finished()

this.app.image = new Image