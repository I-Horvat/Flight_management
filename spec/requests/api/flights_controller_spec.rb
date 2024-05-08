require 'rails_helper'

RSpec.describe Api::FlightsController, type: :controller do
  let(:company) { create(:company) }
  let(:flight) { create(:flight, company: company) }
  let(:user) { create(:user) }

  before do
    request.headers['HTTP_AUTHORIZATION'] = user.token
  end

  describe 'GET ' do
    it 'responds with the correct HTTP status code' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'responds with the correct number of records' do
      create_list(:flight, 3)
      get :index
      expect(JSON.parse(response.body)['flights'].count).to eq(3)
    end
  end

  describe 'POST' do
    context 'with valid params' do
      it 'responds with the correct HTTP status code' do
        flight.name = 'test flight'
        post :create, params: { flight: flight.attributes }
        expect(response).to have_http_status(:created)
      end

      it 'responds with correct attributes' do
        flight.name = 'new flight'
        post :create, params: { flight: flight.attributes }
        expect(JSON.parse(response.body)['flight']['name']).to eq(flight.name)
      end

      it 'creates a new flight' do
        expect do
          post :create, params: { flight: flight.attributes }
        end.to change(Flight, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'responds with the correct HTTP status code' do
        flight.name = nil
        post :create, params: { flight: flight.attributes }
        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with correct error keys' do
        flight.name = nil
        post :create, params: { flight: flight.attributes }
        expect(JSON.parse(response.body)).to include('errors')
      end
    end
  end

  describe 'GET by id ' do
    let(:flight) { create(:flight) }

    it 'responds with the correct HTTP status code' do
      get :show, params: { id: flight.id }
      expect(response).to have_http_status(:ok)
    end

    it 'responds with correct attributes' do
      get :show, params: { id: flight.id }

      expect(JSON.parse(response.body)['flight']['name']).to eq(flight.name)
    end
  end

  describe 'PATCH' do
    let!(:flight) { create(:flight) }

    context 'with valid params' do
      it 'responds with the correct HTTP status code' do
        put :update, params: { id: flight.id, flight: { name: 'Updated Flight Name' } }
        expect(response).to have_http_status(:ok)
      end

      it 'responds with correct attributes' do
        put :update, params: { id: flight.id, flight: { name: 'Updated Flight Name' } }
        flight.reload
        expect(JSON.parse(response.body)['flight']['name']).to eq('Updated Flight Name')
      end

      it 'updates are persisted in the database' do
        put :update, params: { id: flight.id, flight: { name: 'Updated Flight Name' } }
        flight.reload
        expect(flight.name).to eq('Updated Flight Name')
      end
    end

    context 'with invalid params' do
      it 'responds with the correct HTTP status code' do
        put :update, params: { id: flight.id, flight: { name: nil } }
        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with correct error keys' do
        put :update, params: { id: flight.id, flight: { name: nil } }
        expect(JSON.parse(response.body)).to include('errors')
      end
    end
  end
end
