require 'rails_helper'

RSpec.describe Api::CompaniesController, type: :controller do
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
      create_list(:company, 3)
      get :index
      expect(JSON.parse(response.body)['companies'].count).to eq(3)
    end
  end

  describe 'POST ' do
    context 'with valid params' do
      it 'responds with the correct HTTP status code' do
        post :create, params: { company: attributes_for(:company) }
        expect(response).to have_http_status(:created)
      end

      it 'responds with correct attributes' do
        post :create, params: { company: attributes_for(:company) }
        expect(JSON.parse(response.body)['company']['name']).to eq(Company.last.name)
      end

      it 'creates a new company' do
        expect do
          post :create, params: { company: attributes_for(:company) }
        end.to change(Company, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'responds with the correct HTTP status code' do
        post :create, params: { company: attributes_for(:company, name: nil) }
        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with correct error keys' do
        post :create, params: { company: attributes_for(:company, name: nil) }
        expect(JSON.parse(response.body)).to include('errors')
      end
    end
  end

  describe 'GET by id' do
    let(:company) { create(:company) }

    it 'responds with the correct HTTP status code' do
      get :show, params: { id: company.id }
      expect(response).to have_http_status(:ok)
    end

    it 'responds with correct attributes' do
      get :show, params: { id: company.id }
      expect(JSON.parse(response.body)['company']['name']).to eq(company.name)
    end
  end

  describe 'PATCH ' do
    let!(:company) { create(:company) }

    context 'with valid params' do
      it 'responds with the correct HTTP status code' do
        put :update, params: { id: company.id, company: { name: 'Updated Company Name' } }
        expect(response).to have_http_status(:ok)
      end

      it 'responds with correct attributes' do
        put :update, params: { id: company.id, company: { name: 'Updated Company Name' } }
        company.reload
        expect(JSON.parse(response.body)['company']['name']).to eq('Updated Company Name')
      end

      it 'updates are persisted in the database' do
        put :update, params: { id: company.id, company: { name: 'Updated Company Name' } }
        company.reload
        expect(company.name).to eq('Updated Company Name')
      end
    end

    context 'with invalid params' do
      it 'responds with the correct HTTP status code' do
        put :update, params: { id: company.id, company: { name: nil } }
        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with correct error keys' do
        put :update, params: { id: company.id, company: { name: nil } }
        expect(JSON.parse(response.body)).to include('errors')
      end
    end
  end
end
