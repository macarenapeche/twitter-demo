module Api
  class LikesController < ApplicationController
    before_action :get_tweet

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
      @like = Like.find(params[:id])
      @like.destroy
    end

    private

    def get_tweet
      @tweet = Tweet.find(params[:tweet_id])
    end

    def likes_params
      params.permit(:tweet_id, :user_id)
    end
  end
end
