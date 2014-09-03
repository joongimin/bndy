class Comment
  constructor: ->
    $.getScript("/comments")

  prepend: (html) ->
    $comment = $(html).prependTo($("#comments")).hide().css(opacity: 0)
    final_height = $comment.height() + 20
    $comment_height = $("<div class='comment-height'></div>").prependTo($("#comments"))
    setTimeout (->
      $comment_height.css(height: final_height)
      setTimeout (->
        $comment_height.remove()
        $comment.show()
        setTimeout (->
          $comment.css(opacity: '')
          ), 100
        ), 220
      ), 100

app.comment = new Comment