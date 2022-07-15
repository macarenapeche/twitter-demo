class ApplicationController < ActionController::Base
  # REVIEW: if we stop using `@current_user`, we will be able to drop this line
  before_action :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user_logged_in!
    redirect_to log_in_path, alert: 'You must be logged in' if @current_user.nil?
  end
end
