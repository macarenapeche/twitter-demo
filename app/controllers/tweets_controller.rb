class TweetsController < ApplicationController
  before_action :require_user_logged_in!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  before_action :set_user_options, only: [:new, :create, :edit, :update]

  def index
    @tweets = Tweet.all
  end

  def show
  end

  def new
    @tweet = Tweet.new
  end

  def edit
  end


  def create
    @tweet = @current_user.tweets.new(tweet_params)
    if @tweet.save
      flash[:notice] = "Tweet successfully created"
      redirect_to @tweet
    else
      render 'new'
    end

  end

  def update
    if @tweet.update(tweet_params)
      redirect_to @tweet
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

  def set_user_options
    @user_options = User.pluck(:handle, :id)
  end

  def tweet_params
    params.require(:tweet).permit(:user_id, :content)
  end

end
