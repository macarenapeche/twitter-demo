module Api
  class LikesController < ApplicationController
    before_action :get_tweet

    def index
      @likes = @tweet.likes
      render json: @likes
    end

    def get_tweet
      @tweet = Tweet.find(params[:tweet_id])
    end
  end
end
