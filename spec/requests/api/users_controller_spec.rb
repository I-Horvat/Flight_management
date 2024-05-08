require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  let(:user) { create(:user) }

  before do
    request.headers['HTTP_AUTHORIZATION'] = user.token
  end

  describe 'GET' do
    it 'responds with the correct HTTP status code' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'responds with the correct number of records' do
      create_list(:user, 3)
      get :index
      expect(JSON.parse(response.body)['users'].count).to eq(4)
    end
  end

  describe 'POST ' do
    context 'with valid params' do
      it 'responds with the correct HTTP status code' do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to have_http_status(:created)
      end

      it 'responds with correct attributes' do
        post :create, params: { user: attributes_for(:user) }
        expect(JSON.parse(response.body)['user']['first_name']).to eq(User.last.first_name)
      end

      it 'creates a new user' do
        expect do
          post :create, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'responds with the correct HTTP status code' do
        post :create, params: { user: attributes_for(:user, email: nil) }
        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with correct error keys' do
        post :create, params: { user: attributes_for(:user, email: nil) }
        expect(JSON.parse(response.body)).to include('errors')
      end
    end
  end

  describe 'GET ' do
    it 'responds with the correct HTTP status code' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:ok)
    end

    it 'responds with correct attributes' do
      get :show, params: { id: user.id }
      expect(JSON.parse(response.body)['user']['first_name']).to eq(user.first_name)
    end
  end

  describe 'PATCH ' do
    context 'with valid params' do
      it 'responds with the correct HTTP status code' do
        put :update, params: { id: user.id, user: { first_name: 'Updated Name',
                                                    password: '123',
                                                    email: 'email@email.com' } }
        expect(response).to have_http_status(:ok)
      end

      it 'responds with correct attributes' do
        put :update,
            params: { id: user.id, user: { first_name: 'Updated Name', password: '123' } }
        user.reload
        expect(JSON.parse(response.body)['user']['first_name']).to eq('Updated name')
      end

      it 'updates are persisted in the database' do
        put :update,
            params: { id: user.id, user: { first_name: 'Updated Name', password: '123' } }
        user.reload
        expect(user.first_name).to eq('Updated Name')
      end
    end

    it 'responds with correct error keys' do
      put :update, params: { id: user.id, user: { email: nil } }
      expect(JSON.parse(response.body)).to include('errors')
    end
  end
end
