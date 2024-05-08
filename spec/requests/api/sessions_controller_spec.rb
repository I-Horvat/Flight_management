# frozen_string_literal: true

RSpec.describe Api::SessionsController, type: :controller do
  describe 'POST create' do
    let(:user) { create(:user, email: 'marko@email.com', password: '123') }

    context 'with valid credentials' do
      it 'returns a session token and user information' do
        post :create, params: { session: { email: user.email, password: '123' } }

        expect(response).to have_http_status(:created)
        body = JSON.parse(response.body)
        session = body['session']

        expect(session).to have_key('token')
        expect(session).to have_key('user')
      end
    end

    context 'with invalid credentials' do
      it 'returns an error message and 401 status' do
        post :create, params: { session: { email: user.email, password: 'wrong_password' } }

        expect(response).to have_http_status(:bad_request)
        body = JSON.parse(response.body)
        expect(body).to include('errors' => { 'credentials' => ['are invalid'] })
      end
    end
  end
end
