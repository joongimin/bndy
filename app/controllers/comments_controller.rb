class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    @comments = Comment.order(id: :desc)
  end

  def create
    @comment = Comment.new(comment_params)
    if !@comment.save
      respond_with_error(@comment)
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:message)
    end
end
