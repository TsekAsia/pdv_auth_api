require 'rails_helper'

describe 'GET api/companies/:id/membership' do
  let(:token) do
    a = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1NTY3Nzk0NTB9.'
    b = 'kF0VyQtPNpYZ8B5uLMuAPcq2gkzWA6JtpOwJgQTk8Cs'

    "#{a}#{b}"
  end

  before do
    VCR.use_cassette('auth_login_valid_token') do
      VCR.use_cassette('accounts_get_success') do
        VCR.use_cassette('company_find') do
          VCR.use_cassette('company_membership') do
            get membership_api_company_url('discipline-success'), headers: {
              'Authorization': "Token #{token}"
            }, as: :json
          end
        end
      end
    end
  end

  describe 'GET membership' do
    it 'responds with success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns a membership hash' do
      expect(json.keys).to contain_exactly(:company, :user, :created_at, :role)
    end
  end
end
