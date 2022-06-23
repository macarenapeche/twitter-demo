class LikesController < ApplicationController
  before_action :get_tweet
  before_action :set_user_options, only: [:new, :create]

  def index
    @likes = @tweet.likes
  end
  
  def new
    @like = @tweet.likes.build
  end

  def create
    @like = @tweet.likes.build(likes_params)
    if @like.save
    else 
      render "new"
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy
    redirect_to tweet_likes_path(@tweet), status: :see_other
  end

  private 

  def get_tweet
    @tweet = Tweet.find(params[:tweet_id])
  end

  def set_user_options
    @user_options = User.pluck(:handle, :id)
  end
  
  def likes_params
    params.require(:like).permit(:tweet_id, :user_id)
  end

end
