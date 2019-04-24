require 'rails_helper'

describe 'POST api/auth/validate' do
  let(:token) do
    email = 'test@testmail.dev'
    password = 'thisisthepassword'

    VCR.use_cassette('auth_valid_login') do
      token = PdvAuthApi::V1::Auth.new(email: email, password: password).login

      return token
    end
  end

  context 'valid token' do
    before do
      VCR.use_cassette('auth_login_valid_token') do
        post validate_api_auth_index_url, headers: {
          'Authorization': "Token #{token}"
        }, as: :json
      end
    end

    it 'responds with success' do
      expect(response).to have_http_status(:success)
    end
  end

  context 'invalid token' do
    before do
      VCR.use_cassette('auth_invalid_token') do
        post validate_api_auth_index_url, headers: {
          'Authorization': 'Token invalidtoken'
        }, as: :json
      end
    end

    it 'responds with unauthorized' do
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
