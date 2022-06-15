module Api
  class TweetsController < ApplicationController
    def index
      @tweets = Tweet.all
      render json: @tweets 
    end

    def show
      @tweet = Tweet.find(params[:id])
      render json: @tweet
    end

    def create
      @tweet = Tweet.create(tweet_params)
      if @tweet.save
        render json: @tweet, status: :created
      else
        render json: @tweet.errors, status: :unprocessable_entity
      end
    end

    def update
      @tweet = Tweet.find(params[:id])
      if @tweet.update(tweet_params)
        render json: @tweet
      else 
        render json: @tweet.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @tweet = Tweet.find(params[:id])
      @tweet.destroy  
    end

    def tweet_params
      params.permit(:content, :user_id)
    end
  end
end
