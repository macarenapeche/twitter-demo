module Api
  class FollowsController < ApplicationController
    before_action :get_user

    def create
      @follower = User.find(follow_params[:follower_id])
      # REVIEW: instead of this you can do smth like: 
      # follow = user.passive_follows.build(follower: @follower)
      # if follow.save ...
      # 
      # It would be better because if somebody tries to follow themselves, they'll see the error, not valid response with no changes
      @user.followers << @follower unless @user.followers.include?(@follower)
      render json: @user.followers
    end

    def destroy
      @follow = Follow.find(params[:id])
      @follow.destroy if @user
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
