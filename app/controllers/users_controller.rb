class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :find_user, except: %i(new create index)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  attr_reader :users

  def index
    @users = User.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if user.save
      user.send_activation_email
      flash[:info] = t "activation.text2"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    active_relationships = current_user.active_relationships
    @microposts = user.microposts.paginate page: params[:page]
    if current_user.following? user
      @relationship = active_relationships.find_by followed_id: user.id
    else
      @relationship = active_relationships.build
    end
  end

  def edit; end

  def update
    if user.update_attributes user_params
      flash[:success] = t "edit.text2"
      redirect_to user
    else
      render :edit
    end
  end

  def destroy
    user.destroy
    flash[:success] = t "destroy.text1"
    redirect_to users_url
  end

  private

  attr_reader :user

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id]

    return if user
    flash[:danger] = t "error.text1"
    redirect_to root_url
  end

  def correct_user
    redirect_to root_url unless user.current_user? current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
