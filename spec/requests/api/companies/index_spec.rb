require 'rails_helper'

describe 'GET api/companies' do
  let(:token) do
    a = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0MTksImV4cCI6MTYwMzMzMzczNH0.'
    b = 'O2aa8KBvwRkQ-Zi84P7rkt9_0lm7gZnX_XWghmE7ZaQ'

    "#{a}#{b}"
  end

  before do
    VCR.use_cassette('auth_login_valid_token') do
      VCR.use_cassette('accounts_get_success') do
        VCR.use_cassette('company_all') do
          get api_companies_url, headers: {
            'Authorization': "Token #{token}"
          }, as: :json
        end
      end
    end
  end

  describe 'GET index' do
    it 'responds with success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns an array of companies' do
      expect(json.size).to eq(2)
    end

    it 'returns a company hash' do
      expect(json.first.keys).to contain_exactly(
        :name, :slug, :created_at, :disabled_at
      )
    end
  end
end
