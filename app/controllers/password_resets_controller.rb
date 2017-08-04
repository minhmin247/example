class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration,
    only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase

    if user
      send_reset_mail
    else
      flash.now[:danger] = t "reset.text2"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      empty_password
    elsif user.update_attributes user_params
      update_success
    else
      render :edit
    end
  end

  private

  attr_reader :user

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    @user = User.find_by email: params[:email]

    return if user
    flash[:danger] = t "error.text1"
    redirect_to root_path
  end

  def valid_user
    return if user && user.activated? && user.authenticated?(
      :reset, params[:id])
    redirect_to root_url
  end

  def send_reset_mail
    user.create_reset_digest
    user.send_password_reset_email
    flash[:info] = t "reset.text1"
    redirect_to root_url
  end

  def check_expiration
    return unless user.password_reset_expired?
    flash[:danger] = t "reset.text10"
    redirect_to new_password_reset_url
  end

  def empty_password
    user.errors.add :password, t("error.text4")
    render :edit
  end

  def update_success
    user.update_attributes reset_digest: nil
    log_in user
    flash[:success] = t "reset.text9"
    redirect_to user
  end
end
