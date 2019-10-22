require 'rails_helper'

describe 'GET api/account' do
  let(:email) { 'test@testmail.dev' }
  let(:password) { 'thisisthepassword' }

  before do
    token = ''

    VCR.use_cassette('auth_valid_login') do
      VCR.use_cassette('accounts_get_success') do
        token = PdvAuthApi::V1::Auth.new(
          email: email, password: password
        ).login
      end
    end

    VCR.use_cassette('auth_login_valid_token') do
      VCR.use_cassette('accounts_get_success') do
        get api_account_url, headers: {
          'Authorization': "Token #{token}"
        }, as: :json

        @user = PdvAuthApi::V1::Account.new(token: token).fetch
      end
    end
  end

  describe 'GET show' do
    it 'responds with success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns a user object' do
      expect(json.keys).to contain_exactly(
        :id, :username, :first_name, :last_name, :middle_name, :email,
        :created_at, :updated_at, :disabled_at, :membership,
        :require_password_reset, :role
      )
    end

    it 'matches current user' do
      expect(json[:id]).to eq(@user.id)
      expect(json[:username]).to eq(@user.username)
    end
  end
end
