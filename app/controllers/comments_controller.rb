class CommentsController < ApplicationController
  before_action :get_tweet
  before_action :set_comment, only: [:edit, :update, :destroy]

  def index
    @comments = @tweet.comments
  end

  def new
    @user_options = User.other_users_handle_id(@tweet.user_id)
    @comment = Comment.new
  end

  def create
    @comment = @tweet.comments.build(comment_params)
    if @comment.save
      redirect_to @tweet
    else 
      render :new
    end
  end

  def edit
    @user_options = User.other_users_handle_id(@tweet.user_id)
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      redirect_to @tweet
    else 
      render :edit
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to tweets_path, status: :see_other
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
end
