class FollowsController < ApplicationController
  before_action :get_user

  def new
    @user_options = User.select{ |u| u != @user }.map{ |u| [ u.handle, u.id ] }
    @follow = Follow.new
  end

  def create
    @follower = User.find(follow_params[:follower_id])
    @user.followers << @follower unless @user.followers.include?(@follower)
    redirect_to followers_user_path(@user)
  end 

  def destroy
    @follow = Follow.find(params[:id])
    @follow.destroy
    redirect_to followers_user_path(@user),  status: :see_other
  end
  
  private 

  def get_user
    @user = User.find(params[:user_id])
  end

  def follow_params
    params.require(:follow).permit(:user_id, :follower_id)
  end
end
