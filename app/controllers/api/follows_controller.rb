module Api
  class FollowsController < ApplicationController

    def create
      @user = User.find(params[:user_id])
      @follower = User.find(follow_params[:follower_id])
      @user.followers << @follower unless @user.followers.include?(@follower)
      render json: @user.followers
    end

    def destroy
      @follow = Follow.find(params[:id])
      @follow.destroy
    end
    
    private 
  
    def get_user
      @user = User.find(params[:user_id])
    end
  
    def follow_params
      params.require(:follow).permit(:user_id, :follower_id)
    end
  end
end
