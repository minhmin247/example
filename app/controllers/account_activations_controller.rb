class AccountActivationsController < ApplicationController
  private

  attr_reader :user

  public

  def edit
    @user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(
      :activation, params[:id])
      active_success
    else
      flash[:danger] = t "activation.text4"
      redirect_to root_url
    end
  end

  private

  def active_success
    user.activate
    log_in user
    flash[:success] = t "activation.text3"
    redirect_to user
  end
end
