require 'rails_helper'

describe 'POST api/registrations' do
  let(:email) { 'test@test.dev' }
  let(:password) { 'thisisthepassword' }
  let(:params) do
    {
      registration: {
        email: email,
        password: password,
        password_confirmation: password
      }
    }
  end

  describe 'POST create' do
    context 'valid registration' do
      before do
        VCR.use_cassette('registrations_valid_post') do
          post api_registrations_url, params: params, as: :json
        end
      end

      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns a user object' do
        expect(json.keys).to contain_exactly(
          :id, :first_name, :middle_name, :last_name, :username,
          :email, :created_at, :updated_at, :disabled_at, :membership,
          :require_password_reset, :role
        )
      end
    end

    context 'invalid registration' do
      before do
        VCR.use_cassette('registrations_with_errors_post') do
          diff_password = 'thisisNOTthepassword'

          params[:registration][:email] = 'notanemail'
          params[:registration][:password_confirmation] = diff_password

          post api_registrations_url, params: params, as: :json
        end
      end

      it 'responds with unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        expect(json.keys).to contain_exactly(:errors)
      end
    end
  end
end
