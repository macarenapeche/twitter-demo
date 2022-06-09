class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]

  def index
    @tweets = Tweet.all
  end

  def show
  end

  def new
    @user_options = User.all.map{ |u| [ u.handle, u.id ] }
    @tweet = Tweet.new
  end

  def edit
    @user_options = User.all.map{ |u| [ u.handle, u.id ] }
  end


  def create
    @tweet = Tweet.new(tweet_params)
    if @tweet.save
      redirect_to user_path(@tweet.user)
    else
      render 'new'
    end

  end

  def update
    if @tweet.update(tweet_params)
      redirect_to user_path(@tweet.user)
    else
      render 'edit'
    end
  end

  def destroy
    @tweet.destroy
    redirect_to tweets_path, status: :see_other
  end

  private

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def tweet_params
    params.require(:tweet).permit(:user_id, :content)
  end

end
