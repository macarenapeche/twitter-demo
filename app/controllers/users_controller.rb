class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end


  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "User successfully created"
      redirect_to @user
    else
      render 'new'
    end

  end

  def update
    if @user.update(user_params)
      flash[:notice] = "User successfully updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, status: :see_other
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @following = @user.following
    render 'show_following'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @followers = @user.followers
    render 'show_followers'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :handle, :email, :bio)
  end

end
