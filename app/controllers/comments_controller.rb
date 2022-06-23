class CommentsController < ApplicationController
  before_action :get_tweet
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :set_user_options, only: [:new, :create, :edit, :update]

  def index
    @comments = @tweet.comments
    redirect_to @tweet
  end

  def new
    @comment = @tweet.comments.build
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
  end

  def update
    if @comment.update(comment_params)
      redirect_to @tweet
    else 
      render :edit
    end
  end

  def destroy
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

  def set_user_options
    @user_options = User.pluck(:handle, :id)
  end

  def comment_params
    params.permit(:content, :tweet_id, :user_id)
  end
end
