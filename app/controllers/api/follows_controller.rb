module Api
  class FollowsController < ApplicationController
    before_action :get_user, :authorize_request
    before_action :get_follow, :forbidden_action, only: [:destroy]

    def create
      # REVIEW: instead of this you can do smth like: 
      # follow = user.passive_follows.build(follower: @follower)
      # if follow.save ...
      # 
      # It would be better because if somebody tries to follow themselves, they'll see the error, not valid response with no changes
      @user.followers << @current_user unless @user.followers.include?(@current_user)
      render json: @current_user.following
    end

    def destroy
      @follow.destroy if @user
    end
    
    private 
  
    def get_user
      @user = User.find(params[:user_id])
    end

    def get_follow
      @follow = Follow.find(params[:id])
    end

    def forbidden_action
      render json: { "errors": "Unauthorized" }, status: :unauthorized if @current_user.id != @follow.follower_id 
    end
  end
end
