module Api
  class FollowsController < ApplicationController

    def create
      @user = User.find(params[:user_id])
      @follower = User.find(params[:follow][:follower_id])
      @user.followers << @follower unless @user.followers.include?(@follower)
      render json: @user.followers, include: "", status: :created
    end

    def destroy
      @follow = Follow.find(params[:id])
      @follow.destroy
    end
  end
end
