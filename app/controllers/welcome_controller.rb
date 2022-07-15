class WelcomeController < ApplicationController
  def index
  end

  def about
    if user = authenticate_with_http_basic { |u, p| User.find_by(email: u)&.authenticate(p) }
      @current_user = user
    else
      request_http_basic_authentication
    end
  end
end
