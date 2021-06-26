class SessionsController < ApplicationController
  before_action :logged_in_redirect, only: %i[new create]
  def new; end

  def create
    user = User.find_by(username: params[:session][:username].downcase)
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = 'Logged in successfully'
      redirect_to root_path
    else
      flash.now[:error] = "Couldn't login at this time. Please check your credentials."
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'Successfully logged out'
    redirect_to login_path
  end

  private

  def logged_in_redirect
    if logged_in?
      flash[:error] = 'You are already logged in'
      redirect_to root_path
    end
  end
end
