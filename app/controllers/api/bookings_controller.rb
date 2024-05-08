module Api
  class BookingsController < ApplicationController
    before_action :set_booking, only: [:show, :update, :destroy]
    before_action :authenticate_user

    def create
      booking = if params[:booking][:user_id].present?
                  Booking.new(booking_params)
                else
                  @authenticated_user.bookings.new(booking_params)
                end
      if booking.save
        render json: real_render(booking), status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def index
      @bookings = policy_scope(Booking)
      authorize @bookings
      render json: BookingBlueprint.render(@bookings, root: root), status: :ok
    end

    def show
      authorize @booking
      render json: render_booking, status: :ok
    end

    def update
      authorize @booking
      if @booking.update(booking_params)
        render json: render_booking, status: :ok
      else
        render json: { errors: @booking.errors }, status: :bad_request
      end
    end

    def destroy
      authorize @booking
      @booking.destroy
      head :no_content
    end

    private

    def real_render(booking)
      BookingBlueprint.render(booking, root: root.present? ? root.singularize : nil)
    end

    def render_booking
      BookingBlueprint.render(@booking, root: root.present? ? root.singularize : nil)
    end

    def set_booking
      @booking = Booking.find(params[:id])
    end

    def booking_params
      params.require(:booking).permit(policy(Booking).permitted_attributes)
    end

    def root
      if request.headers['HTTP_X_API_SERI ALIZER_ROOT'] == '1' ||
         request.headers['HTTP_X_API_SERIALIZER_ROOT'].blank?
        'bookings'
      end
    end

    def authenticate_user
      auth_token = request.headers['Authorization']
      @authenticated_user = User.find_by(token: auth_token)
      return unless auth_token.nil? || @authenticated_user.nil?

      render json: { "errors": { "token": ['is invalid'] } },
             status: :unauthorized
    end

    def current_user
      @authenticated_user
    end
  end
end
