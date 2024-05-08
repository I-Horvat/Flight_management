# frozen_string_literal: true

class BookingBlueprint < Blueprinter::Base
  identifier :id
  field :no_of_seats
  field :seat_price
  field :created_at
  field :updated_at
  association :user, blueprint: UserBlueprint
  association :flight, blueprint: FlightBlueprint
end
