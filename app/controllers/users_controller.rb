class UsersController < ApplicationController
  before_action :find_user
  before_action :authenticate_user!

  def index
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def find_user
    @user = params[:id] ? User.find(params[:id]) : current_user
  end
end