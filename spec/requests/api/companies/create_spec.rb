require 'rails_helper'

describe 'POST api/companies' do
  let(:token) do
    a = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0MTksImV4cCI6MTYwMzMzMzczNH0.'
    b = 'O2aa8KBvwRkQ-Zi84P7rkt9_0lm7gZnX_XWghmE7ZaQ'

    "#{a}#{b}"
  end

  let(:params) { { name: 'ZZYZX', slug: 'zzyzx' } }

  before do
    VCR.use_cassette('auth_login_valid_token') do
      VCR.use_cassette('accounts_get_success') do
        VCR.use_cassette('company_create') do
          post api_companies_url, params: params, headers: {
            'Authorization': "Token #{token}"
          }, as: :json
        end
      end
    end
  end

  describe 'POST create' do
    it 'responds with success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns a company object' do
      expect(json.keys).to contain_exactly(
        :created_at, :name, :slug, :disabled_at
      )
    end

    it 'creates a company' do
      expect(json[:name]).to eq(params[:name])
      expect(json[:slug]).to eq(params[:slug])
    end
  end
end
