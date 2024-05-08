# frozen_string_literal: true

module Api
  class SessionsController < ApplicationController
    def create
      @user = User.find_by(email: params[:session][:email])

      if @user&.authenticate(params[:session][:password])
        session = Session.new(@user, @user.token)
        render json: session, status: :created
      else
        render json: { 'errors' => { 'credentials' => ['are invalid'] } }, status: :bad_request
      end
    end

    def destroy
      auth_token = request.headers['HTTP_AUTHORIZATION']
      return render_unauthorized if auth_token.blank?

      @user = User.find_by(token: auth_token)
      return render_unauthorized unless @user

      @user.regenerate_token
      head :no_content
    end

    private

    def render_unauthorized
      render json: { errors: { token: ['is invalid'] } }, status: :unauthorized
    end

    def current_user
      @user
    end
  end
end
