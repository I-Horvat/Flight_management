# RSpec.describe 'Api::BookingsController', type: :request do
#   describe 'POST /api/bookings' do
#     it 'responds correctly' do
#       user = create(:user)
#       flight = create(:flight)
#
#       post '/api/bookings',
#            params: { booking: { flight_id: flight.id, no_of_seats: 30, seat_price: 150 } }
# .to_json,
#            headers: {
#              'Authorization' => user.token,
#              'Content-Type' => 'application/json'
#            }
#
#       puts(response.body)
#       puts "Number of bookings for user: #{user.bookings.count}"
#       expect(response).to have_http_status(:created)
#     end
#   end
# end
