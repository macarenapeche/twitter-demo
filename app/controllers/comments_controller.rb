class CommentsController < ApplicationController
  before_action :get_tweet
  before_action :require_user_logged_in!, except: :index
  before_action :set_comment, only: [:edit, :update, :destroy]

  def index
    @comments = @tweet.comments
    redirect_to @tweet
  end

  def new
    @comment = @tweet.comments.build
  end

  def create
    @comment = @tweet.comments.build(comment_params)
    @comment.user_id = @current_user.id
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
    redirect_to tweet_path(@tweet), status: :see_other
  end

  private

  def get_tweet
    @tweet = Tweet.find(params[:tweet_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :tweet_id)
  end
end
