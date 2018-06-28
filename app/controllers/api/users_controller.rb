module Api
  class UsersController < BaseController
    before_action :find_user, only: %i[show edit update destroy]

    def index
      @users ||= User.all
      render json: { users: @users }
    end

    def show
      render json: { user: @user }
    end

    def create
      user = User.new(user_params)
      if user.save
        # give token
        render json: { msg: 'User was created' }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessible_entity
      end
    end

    def update
      if @user.update(user_params)
        render json: { msg: "User '#{@user.username}' was updated" }
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessible_entity
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
end
