class ApplicationController < ActionController::Base
  include Pundit::Authorization
  skip_before_action :verify_authenticity_token
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_error
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def render_not_found_error
    render json: { error: 'Record not found' }, status: :not_found
  end

  def user_not_authorized
    render json: { errors: { resource: ['is forbidden'] } }, status: :forbidden
  end
end
