class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :followers, :following]

  def index
    @users = User.all
  end

  def show
  end

  def new
    if @current_user 
      flash[:notice] = "You cannot create a new user while logged in"
      redirect_to root_path, status: :forbidden
    else 
      @user = User.new
    end
      
  end

  def edit
    if @current_user != @user 
      flash[:notice] = "You cannot update another user's information"
      redirect_to @user, status: :forbidden
    end
  end


  def create
    if @current_user 
      redirect_to root_path, status: :forbidden
    elsif @user = User.new(user_params) && @user.save
      flash[:notice] = "User successfully created"
      session[:user_id] = @user.id
      redirect_to @user
    else
      render 'new'
    end
  end

  def update
    if @current_user != @user 
      redirect_to @user, status: :forbidden
    elsif @user.update(user_params)
      flash[:notice] = "User successfully updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    if @current_user != @user
      redirect_to users_path, status: :forbidden
    else
      @user.destroy
      redirect_to users_path, status: :see_other
    end
  end

  def following
    @follow = Follow.where(follower_id: @user.id).includes(:user)
    render 'show_following'
  end

  def followers
    @follow = Follow.where(user_id: @user.id).includes(:user)
    render 'show_followers'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :handle, :email, :password, :password_confirmation, :bio)
  end

end
