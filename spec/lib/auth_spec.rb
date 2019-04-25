require 'rails_helper'

describe PdvAuthApi::V1::Auth do
  let(:auth) { PdvAuthApi::V1::Auth.new }

  describe '#login' do
    context 'successful login' do
      before do
        VCR.use_cassette('auth_valid_login') do
          VCR.use_cassette('accounts_get_success') do
            auth.email = 'test@testmail.dev'
            auth.password = 'thisisthepassword'

            @login_response = auth.login
          end
        end
      end

      it 'has a status of success' do
        expect(auth.response.status).to eq(200)
      end

      it 'returns a valid token' do
        VCR.use_cassette('auth_login_valid_token') do
          VCR.use_cassette('accounts_get_success') do
            validity = auth.validate

            expect(validity).to eq(true)
          end
        end
      end

      it 'assigns the token to respective attribute' do
        expect(auth.token).to eq(@login_response[:token])
      end

      it 'assigns the user to respective attributes' do
        expect(auth.user).to eq(@login_response[:user])
      end

      it 'returns a hash with token and user' do
        expect(@login_response.keys).to contain_exactly(:user, :token)
      end
    end

    context 'wrong credentials login' do
      before do
        VCR.use_cassette('auth_login_invalid_email') do
          auth.email = 'test@testmail.dev'
          auth.password = 'wrongpassword'

          @login_response = auth.login
        end
      end

      it 'has a status of 401' do
        expect(auth.response.status).to eq(401)
      end

      it 'returns false' do
        expect(@login_response).to eq(false)
      end

      it 'assigns errors' do
        expect(auth.errors.empty?).to eq(false)
      end
    end
  end

  describe '#validate' do
    context 'valid token' do
      before do
        VCR.use_cassette('auth_valid_login') do
          VCR.use_cassette('accounts_get_success') do
            auth.email = 'test@testmail.dev'
            auth.password = 'thisisthepassword'

            @login_response = auth.login
          end
        end

        VCR.use_cassette('auth_login_valid_token') do
          VCR.use_cassette('accounts_get_success') do
            @validate_response = auth.validate
          end
        end
      end

      it 'has a status of success' do
        expect(auth.response.status).to eq(200)
      end

      it 'returns true' do
        expect(@validate_response).to eq(true)
      end
    end

    context 'invalid token' do
      before do
        VCR.use_cassette('auth_invalid_token') do
          auth.token = 'invalid_token'

          @validate_response = auth.validate
        end
      end

      it 'has a status of 401' do
        expect(auth.response.status).to eq(401)
      end

      it 'returns false' do
        expect(@validate_response).to eq(false)
      end
    end
  end
end
