class Api::V1::UsersController < Api::V1::BaseController

    def index
        @users = APIUser.all
        render json: @users, status: :ok
    end

    def create
        @user = APIUser.new
        if @user.save
            render json: @user, status: :ok
        else
            render json: "Could not create user."
        end
    end
end