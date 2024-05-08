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
RSpec.describe Booking, type: :model do
  let(:booking) { build(:booking) }

  it { is_expected.to belong_to(:flight) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:seat_price) }
  it { is_expected.to validate_numericality_of(:no_of_seats).is_greater_than(0) }

  it 'is valid with valid attributes' do
    expect(booking).to be_valid
  end

  it 'is not valid without a seat price' do
    booking.seat_price = nil
    expect(booking).not_to be_valid
  end

  it 'is not valid without a valid number of seats' do
    booking.no_of_seats = 0
    expect(booking).not_to be_valid
  end

  it 'is not valid if the associated flight is in the past' do
    flight = build(:flight, departs_at: Time.zone.now - 1.day)
    booking.flight = flight
    expect(booking).not_to be_valid
  end
end
