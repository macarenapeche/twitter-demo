class FollowsController < ApplicationController
  before_action :get_user, :require_user_logged_in!

  def create
    @user.followers << @current_user unless @user.followers.include?(@current_user)
    redirect_back fallback_location: root_path
  end 

  def destroy
    @follow = Follow.find(params[:id])
    if @current_user.id != @follow.follower_id
      redirect_back fallback_location: root_path, status: :forbidden
    else
      @follow.destroy
      redirect_back fallback_location: root_path, status: :see_other
    end
  end
  
  private 

  def get_user
    @user = User.find(params[:user_id])
  end

  def follow_params
    params.require(:follow).permit(:user_id, :follower_id)
  end
end
