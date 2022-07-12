class ApplicationController < ActionController::Base
  before_action :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user_logged_in!
    redirect_to log_in_path, alert: 'You must be logged in' if @current_user.nil?
  end
end
