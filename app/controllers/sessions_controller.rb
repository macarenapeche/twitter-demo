class SessionsController < ApplicationController
  def new 
  end

  def create
    # Add downcase & strip to email to remove accidental capitals & spaces
    user = User.find_by(email: params[:email].downcase.strip)
    if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Logged in successfully'
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged Out'
  end
end
