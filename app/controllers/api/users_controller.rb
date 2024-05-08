module Api
  class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :destroy, :index]
    before_action :authenticate_user, except: [:create]
    before_action :check_header, only: [:show, :update, :destroy]

    def create
      logged_in_user_is_admin
      user = User.new(user_params)
      authorize @user unless @user.nil?
      if user.save
        render json: UserBlueprint.render(user, root: root.present? ? root.singularize : nil),
               status: :created
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    def index
      if authorize User
        users = policy_scope(User)
        render json: UserBlueprint.render(users, root: root)
      else
        render json: { errors: { token: ['is invalid'] } }, status: :unauthorized
      end
    end

    def show
      user = User.find(params[:id])
      authorize user
      render json: UserBlueprint.render(user, root: root.present? ? root.singularize : nil),
             status: :ok
    end

    def update
      user = User.find(params[:id])
      user = check_missing(user)
      authorize user, :update?
      on_success(user)
    end

    def destroy
      user = User.find(params[:id])
      authorize user
      user.destroy
      head :no_content
    end

    def update_role
      authorize @user
      user = User.find(params[:id])
      authorize user, :update_role?
      user.update(user_params)
    end

    private

    def on_success(user)
      if user.update(user_params)
        render json: UserBlueprint.render(user, root: root.present? ? root.singularize : nil)
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    def check_missing(user)
      %i[first_name email password].each do |attribute|
        if params[:user][attribute].nil?
          user.errors.add(attribute, 'cannot be blank')
        else
          user.errors.add(attribute, '')
        end
      end
      user
    end

    def current_user
      @user
    end

    def logged_in_user_is_admin
      @user = User.find_by(token: request.headers['HTTP_AUTHORIZATION'])
      @user&.admin? || false
    end

    def set_user
      @user = User.find_by(token: request.headers['HTTP_AUTHORIZATION'])
    end

    def user_params
      if !@user.nil?
        params.require(:user).permit(policy(@user).permitted_attributes)
      else
        params.require(:user).permit([:first_name, :last_name, :email, :password])
      end
    end

    def root
      if request.headers['HTTP_X_API_SERIALIZER_ROOT'] == '1' ||
         request.headers['HTTP_X_API_SERIALIZER_ROOT'].blank?
        'users'
      end
    end

    def authenticate_user
      auth_token = request.headers['HTTP_AUTHORIZATION']
      if auth_token.nil? ||
         @user.nil? || @user.id != User.find_by(token: auth_token).id
        render json: { errors: { token: ['is invalid'] } },
               status: :unauthorized
      end
    end

    def check_header
      return true if @user.token == request.headers['HTTP_AUTHORIZATION']

      @user = nil
      render json: { errors: { resource: ['is forbidden'] } }, status: :forbidden
    end
  end
end
