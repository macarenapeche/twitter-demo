module Api
  class CommentsController < ApplicationController
    before_action :get_tweet
    before_action :authorize_request, only: [:create, :update, :destroy]
    before_action :set_comment, :forbidden_action, only: [:update, :destroy]


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
      if @comment.update(comment_params)
        render json: @comment
      else 
        render json: @comment.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @comment.destroy
    end

    private

    def get_tweet
      @tweet = Tweet.find(params[:tweet_id])
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end
  
    def comment_params
      params.permit(:content, :tweet_id, :user_id)
    end

    def forbidden_action
      render json: { "errors": "Unauthorized" }, status: :unauthorized if @current_user.id != @comment.user_id 
    end
  end
end
