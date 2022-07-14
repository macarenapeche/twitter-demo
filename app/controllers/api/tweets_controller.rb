module Api
  class TweetsController < ApplicationController
    before_action :set_tweet, only: [:show, :update, :destroy]
    before_action :authorize_request, only: [:create, :update, :destroy]
    before_action :forbidden_action, only: [:update, :destroy]

    
    def index
      @tweets = Tweet.all
      render json: @tweets 
    end

    def show
      render json: @tweet
    end

    def create
      @tweet = Tweet.create(tweet_params)
      @tweet.user_id = @current_user.id
      if @tweet.save
        render json: @tweet, status: :created
      else
        render json: @tweet.errors, status: :unprocessable_entity
      end
    end

    def update
      if @tweet.update(tweet_params)
        render json: @tweet
      else 
        render json: @tweet.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @tweet.destroy  
    end

    # REVIEW: It's a good idea to separate non-action methods as private
    # At least because whatever is not private, one must test
    private 

    def set_tweet
      @tweet = Tweet.find(params[:id])
    end
    
    def tweet_params
      params.permit(:content)
    end


    def forbidden_action
      render json: { "errors": "Unauthorized" }, status: :unauthorized if @current_user != @tweet.user
    end
  end
end
