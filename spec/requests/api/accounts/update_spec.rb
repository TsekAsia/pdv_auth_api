require 'rails_helper'

describe 'PATCH api/account' do
  let(:email) { 'test@testmail.dev' }
  let(:password) { 'thisisthepassword' }

  let(:params) do
    {
      user: {
        first_name: 'Tony',
        last_name: 'Stark',
        username: 'ironman'
      }
    }
  end

  before do
    token = ''

    VCR.use_cassette('auth_valid_login') do
      VCR.use_cassette('accounts_get_success') do
        token = PdvAuthApi::V1::Auth.new(
          email: email, password: password
        ).login

        @user = PdvAuthApi::V1::Account.new(token: token).fetch
      end
    end

    VCR.use_cassette('auth_login_valid_token') do
      VCR.use_cassette('account_save_success') do
        patch api_account_url, params: params, headers: {
          'Authorization': "Token #{token}"
        }, as: :json
      end
    end
  end

  describe 'POST update' do
    it 'responds with success' do
      expect(response).to have_http_status(:success)
    end
  end
end
