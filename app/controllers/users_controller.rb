class UsersController < ApplicationController
  before_action :find_user
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def update
    if @user.update(user_params)
      redirect_to users_url, notice: "User '#{@user.username}' was updated"
    else
      redirect_to user_url, alert: 'ERROR'
    end
  end

  private

  def user_params
    if current_user.present? && current_user.role?('admin')
      params.require(:user).permit(:username, :email, :password, :role)
    else
      params.require(:user).permit(:username, :email, :password)
    end
  end

  def find_user
    @user = params[:id] ? User.find(params[:id]) : current_user
  end
end