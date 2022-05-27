class FollowsController < ApplicationController
  before_action :get_user
  before_action :set_follower, only: [:destroy]

  def index
    @followers = @user.followers.all
  end

  def new
    @follower = @user.followers.build
  end

  def create
    @follower = @user.followers.build(params.require(:follower).permit(:user_id, :follower_id))
    if @follower.save
      redirect_to user_followers_path(@user)
    else 
      render "new"
    end
  end 

  def destroy
    @follower = @user.followers.find(params[:id])
    @follower.destroy
    redirect_to user_followers_path(@user),  status: :see_other
  end
  
  private 

  def get_user
    @user = User.find(params[:user_id])
  end

end