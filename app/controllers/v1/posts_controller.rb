class V1::PostsController < ApplicationController
  def index
    @posts = Post.all.order(created_at: "DESC", id: "ASC")
    render json: @posts
  end

  def create
    post = Post.new(post_params)

    if post.save
      render json: post, status: :created
    else
      render json: post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    post = Post.find(params[:id])

    # Cloudinary に保存している画像も削除する
    Cloudinary::Api.delete_resources([post.file_name])

    if post.destroy
      render json: post
    end
  end

  private
    def post_params
      params.require(:post).permit(:title, :content, :image, :file_name, :user_id)
    end
end
