require 'rails_helper'

describe PdvAuthApi::V1::Account do
  let(:email) { 'test@testmail.dev' }
  let(:password) { 'thisisthepassword' }
  let(:account) { PdvAuthApi::V1::Account.new }

  describe '.new' do
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

    it 'initiates with no assigned user' do
      expect(account.user.nil?).to eq(true)
    end
  end

  describe '.fetch' do
    context 'valid token' do
      before do
        token = ''

        VCR.use_cassette('auth_valid_login') do
          VCR.use_cassette('accounts_get_success') do
            token = PdvAuthApi::V1::Auth.new(email: email, password: password)
                                        .login
          end
        end

        VCR.use_cassette('accounts_get_success') do
          account.fetch
        end
      end

      it 'fetches an account' do
        expect(account.user.keys).to contain_exactly(
          :created_at, :email, :first_name, :middle_name, :last_name, :id,
          :updated_at, :username
        )
      end

      it 'assigns account to class.user' do
        expect(account.user.nil?).to eq(false)
      end

      it 'fetches account of current user' do
        expect(account.user[:email]).to eq(email)
      end

      it 'responds with 200' do
        expect(account.response.status).to eq(200)
      end
    end

    context 'invalid token' do
      before do
        VCR.use_cassette('account_get_fail') do
          account.token = 'wrongtoken'

          account.fetch
        end
      end

      it 'responds with 401' do
        expect(account.response.status).to eq(401)
      end

      it 'assigns errors' do
        expect(account.errors.empty?).to eq(false)
      end
    end
  end
end
