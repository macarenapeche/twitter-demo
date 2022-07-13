class LikesController < ApplicationController
  before_action :get_tweet
  before_action :require_user_logged_in!, only: [:create]

  def index
    @likes = @tweet.likes
  end

  def create      
    @tweet.likes.build(user_id: @current_user.id).save!
    redirect_back fallback_location: root_path
  end

  def destroy
    @like = Like.find(params[:id])
    if @current_user.id != @like.user_id
      redirect_back fallback_location: root_path, status: :forbidden
    else
      @like.destroy
      redirect_back fallback_location: root_path, status: :see_other
    end
  end

  private 

  def get_tweet
    @tweet = Tweet.find(params[:tweet_id])
  end
end
