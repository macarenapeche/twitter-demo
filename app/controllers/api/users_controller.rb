module Api
  class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :destroy, :followers, :following]
    before_action :authorize_request, only: [:update, :destroy]
    before_action :forbidden_action, only: [:update, :destroy]

    def index
      @users = User.all
      # render json: @users # default: include only direct associations
      # render json: @users, include: '' # include no associations
      # render json: @users, include: '**' # include all associations
      # render json: @users, include: :tweets # include some associations
      # render json: @users, include: { tweets: %i[likes author] } # include some associations
      # render json: @users, include: { tweets: [:likes, author: :likes] } # include some associations
      render json: @users, include: %i[tweets followers following]
    end

    def show
      render json: @user
    end

    def create
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      decoded = JsonWebToken.decode(header) if header

      if decoded && User.ids.include?(decoded[:user_id])
        render json: { "errors": "Users cannot be created while logged in"}, status: :unauthorized
      else 
        @user = User.create(user_params)
        if @user.save
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end
    end

    def update
      if @user.update(user_params)
        render json: @user.reload
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy      
    end

    def following
      render json: @user.following
    end
  
    def followers
      render json: @user.followers
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :handle, :email, :password, :password_confirmation, :bio)
    end

    def forbidden_action
      render json: { "errors": "Unauthorized" }, status: :unauthorized if @current_user != @user 
    end

  end
end
