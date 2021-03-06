class V1::UsersController < ApplicationController
  def index
    case
    when params[:id]
      @user = User.where(id: params[:id]).includes(:posts).order("posts.created_at DESC")
      render json: @user
    when params[:uid]
      @user = User.find_by(uid: params[:uid])
      render json: @user
    else
      @users = User.all
      render json: @users
    end
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])

    # ユーザがプロフィール画像を削除したら cloudinary に保存してある画像も削除する
    if params[:profile_image] == nil && params[:file_name] == nil
      Cloudinary::Api.delete_resources([@user.file_name]) if @user.file_name
    end

    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])

    if user.file_name
      Cloudinary::Api.delete_resources([user.file_name])
    end

    if user.destroy
      render json: user
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :uid, :admin, :profile_image, :file_name)
    end
end
