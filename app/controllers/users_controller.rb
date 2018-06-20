class UsersController < ApplicationController
  before_action :find_user, only: %i[show edit update destroy]
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def find_user
    @book = User.find(params[:id])
  end
end
