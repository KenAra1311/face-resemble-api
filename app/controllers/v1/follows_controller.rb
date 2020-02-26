class V1::FollowsController < ApplicationController
  def index
    case
    when params[:follow_id]
      @follows = Follow.where(follow_id: params[:follow_id]).order(created_at: "DESC", id: "ASC")
      render json: @follows
    else
      @follows = Follow.all
      render json: @follows
    end
  end

  def create
    follow = Follow.new(follow_params)

    if follow.save
      render json: follow, status: :created
    else
      render json: follow.errors, status: :unprocessable_entity
    end
  end

  def destroy
    follow = Follow.find(params[:id])

    if follow.destroy
      render json: follow
    end
  end

  private
    def follow_params
      params.require(:follow).permit(:user_id, :follow_id)
    end
end
