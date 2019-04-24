require 'rails_helper'

describe 'POST api/auth' do
  let(:email) { 'test@testmail.dev' }
  let(:password) { 'thisisthepassword' }

  let(:params) { { auth: { email: email, password: password } } }

  describe 'POST create' do
    context 'successful login' do
      before do
        VCR.use_cassette('auth_valid_login') do
          post api_auth_index_url, params: params, as: :json
        end
      end

      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns a valid token' do
        VCR.use_cassette('auth_login_valid_token') do
          validity = PdvAuthApi::V1::Auth.new(token: json[:auth_token]).validate

          expect(validity).to eq(true)
        end
      end
    end

    context 'invalid login' do
      before do
        VCR.use_cassette('auth_login_invalid_email') do
          params[:auth][:password] = 'wrongpassword'

          post api_auth_index_url, params: params, as: :json
        end
      end

      it 'responds with unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(json.keys).to contain_exactly(:errors)
      end
    end
  end
end
