require 'rails_helper'
RSpec.describe Api::BookingsController, type: :controller do
  let(:user) { create(:user) }
  let(:flight) { create(:flight) }
  let(:booking) { build(:booking, user: user, flight: flight) }

  before do
    request.headers['HTTP_AUTHORIZATION'] = user.token
    request.headers['CONTENT_TYPE'] = 'application/json'
  end

  describe 'GET ' do
    it 'responds with the correct HTTP status code' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'responds with the correct number of records' do
      create_list(:booking, 4)
      get :index

      expect(JSON.parse(response.body)['bookings'].count).to eq(4)
    end
  end

  describe 'POST ' do
    context 'with valid params' do
      it 'responds with the correct HTTP status code' do
        post :create, params: { booking: {
          "flight_id": flight.id,
          "no_of_seats": booking.no_of_seats,
          "seat_price": booking.seat_price
        } }
        expect(response).to have_http_status(:created)
      end

      it 'creates a new booking' do
        expect do
          post :create, params: { booking: {
            "flight_id": flight.id,
            "no_of_seats": booking.no_of_seats,
            "seat_price": booking.seat_price
          } }
        end.to change(Booking, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'responds with the correct HTTP status code' do
        booking.no_of_seats = nil
        post :create, params: { booking: booking.attributes }
        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with correct error keys' do
        booking.no_of_seats = nil
        post :create, params: { booking: booking.attributes }
        expect(JSON.parse(response.body)).to include('errors')
      end
    end
  end

  describe 'GET' do
    let(:booking) { create(:booking) }

    it 'responds with the correct HTTP status code' do
      get :show, params: { id: booking.id }
      expect(response).to have_http_status(:ok)
    end

    it 'responds with correct attributes' do
      get :show, params: { id: booking.id }
      expect(JSON.parse(response.body)['booking']['no_of_seats']).to eq(2)
    end
  end

  describe 'PATCH ' do
    let(:booking) { create(:booking) }

    context 'with valid params' do
      it 'responds with the correct HTTP status code' do
        put :update, params: { id: booking.id, booking: { no_of_seats: 3 } }
        expect(response).to have_http_status(:ok)
      end

      it 'responds with correct attributes' do
        put :update, params: { id: booking.id, booking: { no_of_seats: 3 } }
        booking.reload
        expect(JSON.parse(response.body)['booking']['no_of_seats']).to eq(3)
      end

      it 'updates are persisted in the database' do
        put :update, params: { id: booking.id, booking: { no_of_seats: 3 } }
        booking.reload
        expect(booking.no_of_seats).to eq(3)
      end
    end

    context 'with invalid params' do
      it 'responds with the correct HTTP status code' do
        put :update, params: { id: booking.id, booking: { no_of_seats: nil } }
        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with correct error keys' do
        put :update, params: { id: booking.id, booking: { no_of_seats: nil } }
        expect(JSON.parse(response.body)).to include('errors')
      end
    end
  end

  # slide 26
  describe 'PUT' do
    context 'when authenticated' do
      it 'and authorized' do
        user1 = create(:user)
        user2 = create(:user)
        booking = create(:booking, user: user1, flight: build(:flight))
        put :update, params: { id: booking.id, booking: { user_id: user2.id } }

        expect(response).to have_http_status(:ok)
      end

      it 'but not authorized' do
        user1 = build(:user)
        user2 = create(:user, role: :nil)
        booking = create(:booking, user: user1, flight: build(:flight))
        request.headers['HTTP_AUTHORIZATION'] = user2.token

        put :update, params: { id: booking.id, booking: { user_id: user2.id } }

        expect(response).to have_http_status(:forbidden)
        expect(booking.reload.user).to eq(user1)
      end
    end

    context 'when unathorized' do
      it 'cannot update the user_id attribute' do
        request.headers['HTTP_AUTHORIZATION'] = 'SOME_OTHER_TOKEN'
        user1 = build(:user)
        user2 = create(:user)
        booking = create(:booking, user: user1, flight: build(:flight))

        put :update, params: { id: booking.id, booking: { user_id: user2.id } }

        expect(response).to have_http_status(:unauthorized)
        expect(booking.reload.user).to eq(user1)
      end
    end
  end
end
