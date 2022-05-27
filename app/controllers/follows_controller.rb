class FollowsController < ApplicationController
  
  before_action :get_user

  def index
    @follows = @user.followers
  end

  def show
    @follower = @user.find(params[:id])
  end

  def new
    @follower = @user.followers.build
  end

  def create
    @follower = @user.followers.build(params.require(:follow).permit(:follower_id))
    if @follower.save
      redirect_to user_follows_path(@user)
    else 
      render "new"
    end
  end 

  def destroy
    @follower = Follow.find(params[:id])
    @follower.destroy
    redirect_to user_follows_path(@user),  status: :see_other
  end
  
  private 

  def get_user
    @user = User.find(params[:user_id])
  end

end