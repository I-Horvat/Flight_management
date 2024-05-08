module Api
  class FlightsController < ApplicationController
    before_action :set_flight, only: [:show, :update, :destroy]
    before_action :authenticate_user, except: [:index, :show]
    def create
      @flight = Flight.new(flight_params)
      authorize @flight
      if @flight.save
        render json: FlightBlueprint.render(@flight, root: root.present? ? root.singularize : nil),
               status: :created
      else
        render json: { errors: @flight.errors }, status: :bad_request
      end
    end

    def index
      @flights = Flight.all
      render json: FlightBlueprint.render(@flights, root: root)
    end

    def show
      authorize @flight
      render json: FlightBlueprint.render(@flight, root: root.present? ? root.singularize : nil)
    end

    def update
      authorize @flight
      if @flight.update(flight_params)
        render json: FlightBlueprint.render(@flight, root: root.present? ? root.singularize : nil)
      else
        render json: { errors: @flight.errors }, status: :bad_request
      end
    end

    def destroy
      authorize @flight
      @flight.destroy
      head :no_content
    end

    private

    def set_flight
      @flight = Flight.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Flight not found' }, status: :not_found
    end

    def flight_params
      params.require(:flight).permit(:name, :no_of_seats, :base_price, :departs_at, :arrives_at,
                                     :company_id)
    end

    def root
      if request.headers['HTTP_X_API_SERIALIZER_ROOT'] == '1' ||
         request.headers['HTTP_X_API_SERIALIZER_ROOT'].blank?
        'flights'
      end
    end

    def authenticate_user
      auth_token = request.headers['HTTP_AUTHORIZATION']
      @authenticated_user = User.find_by(token: auth_token)
      return unless auth_token.nil? || @authenticated_user.nil?

      render json: {
               "errors": {
                 "token": ['is invalid']
               }
             },
             status: :unauthorized
    end

    def current_user
      @authenticated_user
    end
  end
end
