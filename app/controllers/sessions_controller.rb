class SessionsController < ApplicationController
  attr_reader :user

  def new; end

  def create
    session = params[:session]
    @user = User.find_by email: session[:email].downcase
    if user && user.authenticate(session[:password])
      login_success user
    else
      login_fail
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def login_success user
    log_in user
    session = params[:session]
    session[:remember_me] == "1" ? remember(user) : forget(user)
    redirect_back_or user
  end

  def login_fail
    flash.now[:danger] = t "error.text2"
    render :new
  end
end
