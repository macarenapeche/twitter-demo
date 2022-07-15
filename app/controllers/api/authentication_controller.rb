module Api
  class AuthenticationController < ApplicationController
    before_action :authorize_request, except: :login

    # POST /login
    def login
      @user = User.find_by_email(login_params[:email])
      if @user&.authenticate(login_params[:password])
        token = JsonWebToken.encode(user_id: @user.id)
        time = Time.now + 24.hours.to_i
        render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                       handle: @user.handle }, status: :ok
      else
        render json: { error: 'Invalid username or password' }, status: :unauthorized
      end
    end

    # GET /logged_user
    def logged_user
      render json: @current_user
    end

    private

    def login_params
      params.permit(:email, :password)
    end
  end
end
