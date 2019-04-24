require 'rails_helper'

describe PdvAuthApi::V1::Account do
  let(:email) { 'test@testmail.dev' }
  let(:token) do
    password = 'thisisthepassword'

    VCR.use_cassette('auth_valid_login') do
      token = PdvAuthApi::V1::Auth.new(email: email, password: password).login

      return token
    end
  end

  let(:account) do
    VCR.use_cassette('accounts_get_success') do
      PdvAuthApi::V1::Account.new(token: token)
    end
  end

  describe '.new' do
    it 'fetches the account on new' do
      expect(account.user[:email]).to eq(email)
    end

    it 'responds to token' do
      expect(account).to respond_to(:token)
      expect(account).to respond_to(:token=)
    end

    it 'responds to user' do
      expect(account).to respond_to(:user)
      expect(account).to respond_to(:user=)
    end

    it 'responds to response' do
      expect(account).to respond_to(:response)
    end
  end
end
