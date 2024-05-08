# frozen_string_literal: true

# == Schema Information
#
# Table name: bookings
#
#  id          :bigint           not null, primary key
#  no_of_seats :integer          not null
#  seat_price  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  flight_id   :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_bookings_on_flight_id  (flight_id)
#  index_bookings_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (flight_id => flights.id)
#  fk_rails_...  (user_id => users.id)
#
class Booking < ApplicationRecord
  validate :flight_not_in_past

  validates :seat_price, presence: true, numericality: { greater_than: 0 }

  validates :no_of_seats, presence: true, numericality: { greater_than: 0 }
  # validate :user_id_immutable, on: :update, if: :user_id_changed?

  belongs_to :user
  belongs_to :flight

  private

  #
  # def user_id_immutable
  #   errors.add(:user_id, 'cannot be changed by non-admin users') unless user.admin?
  # end

  def flight_not_in_past
    return unless flight && flight.departs_at < DateTime.current

    errors.add(:flight, "can't be in the past")
  end
end
