class V1::PostsController < ApplicationController
  def index
    case
    when params[:id]
      @posts = Post.where(id: params[:id]).order(created_at: "DESC", id: "ASC")
      render json: @posts
    when params[:user_id]
      @posts = Post.where(user_id: params[:user_id]).order(created_at: "DESC", id: "ASC")
      render json: @posts
    else
      @posts = Post.all.order(created_at: "DESC", id: "ASC")
      render json: @posts
    end
  end

  def create
    post = Post.new(post_params)

    # ----- Face API の無料期間が過ぎたので、一時感情を取得する機能を停止 -----
    # 感情の最大値を格納
    # emotion = Post.face_detect(params[:post][:image])
    # post[:emotion] = emotion
    # ----- Face API の無料期間が過ぎたので、一時感情を取得する機能を停止 -----

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
      params.require(:post).permit(:title, :content, :image, :file_name, :emotion, :user_id)
    end
end
