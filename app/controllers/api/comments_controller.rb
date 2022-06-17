module Api
  class CommentsController < ApplicationController
    before_action :get_tweet

    def index
      @comments = @tweet.comments
      render json: @comments
    end

    def create
      @comment = @tweet.comments.build(comment_params)
      if @comment.save
        render json: @comment, status: :created
      else 
        render json: @comment.errors, status: :unprocessable_entity
      end
    end

    def update
      @comment = Comment.find(params[:id])
      if @comment.update(comment_params)
        render json: @comment
      else 
        render json: @comment.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @comment = Comment.find(params[:id])
      @comment.destroy
    end

    private

    def get_tweet
      @tweet = Tweet.find(params[:tweet_id])
    end

    def comment_params
      params.permit(:content, :tweet_id, :user_id)
    end
  end
end
