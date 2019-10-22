require 'rails_helper'

describe 'PATCH api/companies/:id' do
  let(:token) do
    a = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0MTksImV4cCI6MTYwMzMzMzczNH0.'
    b = 'O2aa8KBvwRkQ-Zi84P7rkt9_0lm7gZnX_XWghmE7ZaQ'

    "#{a}#{b}"
  end

  let(:params) { { name: 'xzyzz', slug: 'xzyzz' } }

  before do
    VCR.use_cassette('auth_login_valid_token') do
      VCR.use_cassette('accounts_get_success') do
        VCR.use_cassette('company_find') do
          VCR.use_cassette('company_update') do
            patch api_company_url('zzyzx'), params: params, headers: {
              'Authorization': "Token #{token}"
            }, as: :json
          end
        end
      end
    end
  end

  describe 'PATCH create' do
    it 'responds with success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns a company object' do
      expect(json.keys).to contain_exactly(
        :created_at, :name, :slug, :disabled_at
      )
    end

    it 'updates the company' do
      expect(json[:name]).to eq(params[:name])
      expect(json[:slug]).to eq(params[:slug])
    end
  end
end
