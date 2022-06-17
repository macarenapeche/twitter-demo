module Api
  class UsersController < ApplicationController

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
      @user = User.find(params[:id])
      render json: @user
    end

    def create
      @user = User.create(user_params)
      if @user.save
        render json: @user, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy      
    end

    def following
      @user  = User.find(params[:id])
      render json: @user.following
    end
  
    def followers
      @user  = User.find(params[:id])
      render json: @user.followers
    end

    private

    def user_params
      params.permit(:name, :handle, :email, :bio)
    end
  end
end
