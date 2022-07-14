module Api
  class LikesController < ApplicationController
    before_action :get_tweet
    before_action :authorize_request, only: [:create, :destroy]
    before_action :get_like, :forbidden_action, only: [:destroy]

    def index
      @likes = @tweet.likes
      render json: @likes
    end

    def create 
      @like = @tweet.likes.build(likes_params)
      if @like.save
        render json: @like, status: :created
      else 
        render json: @like.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @like.destroy
    end

    private

    def get_tweet
      @tweet = Tweet.find(params[:tweet_id])
    end

    def get_like
      @like = Like.find(params[:id])
    end

    def likes_params
      params.permit(:tweet_id, :user_id)
    end

    def forbidden_action
      render json: { "errors": "Unauthorized" }, status: :unauthorized if @current_user.id != @like.user_id 
    end
  end
end
