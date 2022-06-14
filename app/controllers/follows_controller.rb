class FollowsController < ApplicationController
  
  before_action :get_user

  def index
    @followers = @user.followers
  end

  def show
    @follower = User.find(params[:id])
  end

  def new
    @user_options = User.all.map{ |u| [ u.handle, u.id ] }
    @follow = Follow.new
  end

  def create
    @follow = Follow.create(params.require(:follow).permit(:follower_id, :user_id))
    if @follow.save
      redirect_to @user
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
