class UsersController < ApplicationController
  before_action :find_user, only: %i[index show edit update destroy]
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def find_user
    @user = params[:id] ? User.find(params[:id]) : current_user
  end
end