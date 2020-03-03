class V1::CommentsController < ApplicationController
  def index
    @comment = Comment.all
    render json: @comment
  end

  def create
    comment = Comment.new(comment_params)

    if comment.save
      render json: comment, status: :ok
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    comment = Comment.find(params[:id])

    if comment.destroy
      render json: comment
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:comment, :user_id, :post_id)
    end
end
