class V1::LikesController < ApplicationController
  def index
    @likes = Like.all
    render json: @likes
  end

  def create
    like = Like.new(like_params)

    if like.save
      # いいねの総数も保存
      post = Post.find(like[:post_id])
      post.increment!(:count, 1)

      render json: like, status: :created
    else
      render json: like.errors, status: :unprocessable_entity
    end
  end

  def destroy
    like = Like.find(params[:id])

    if like.destroy
      # いいねの総数も削除
      post = Post.find(like[:post_id])
      post.decrement!(:count, 1)
      render json: like
    end
  end

  private
    def like_params
      params.require(:like).permit(:user_id, :post_id)
    end
end
