require 'rails_helper'

describe 'GET api/companies' do
  let(:token) do
    a = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1NTY3Nzk0NTB9.'
    b = 'kF0VyQtPNpYZ8B5uLMuAPcq2gkzWA6JtpOwJgQTk8Cs'

    "#{a}#{b}"
  end

  before do
    VCR.use_cassette('auth_login_valid_token') do
      VCR.use_cassette('accounts_get_success') do
        VCR.use_cassette('company_find') do
          get api_company_url('discipline-success'), headers: {
            'Authorization': "Token #{token}"
          }, as: :json
        end
      end
    end
  end

  describe 'GET show' do
    it 'responds with success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns a company hash' do
      expect(json.keys).to contain_exactly(
        :name, :slug, :created_at
      )
    end
  end
end
