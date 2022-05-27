class LikesController < ApplicationController
  
  before_action :get_tweet
  before_action :set_like, only: [:show, :destroy]

  def index
    @likes = @tweet.likes
  end

  def show
  end

  def new
    @like = @tweet.likes.build
  end

  def create
    @like = @tweet.likes.build(likes_params)
    if @like.save
      redirect_to tweets_path
    else 
      render "new"
    end
  end

  def destroy
    @like.destroy
    redirect_to tweet_likes_path(@tweet), status: :see_other
  end

  private 

  def get_tweet
    @tweet = Tweet.find(params[:tweet_id])
  end

  def set_like
    @like = @tweet.find(params[:id])
  end

  def likes_params
    params.require(:like).permit(:tweet_id, :user_id)
  end

end