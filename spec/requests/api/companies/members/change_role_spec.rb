require 'rails_helper'

describe 'POST api/companies/:company_id/members/change_role' do
  let(:token) do
    a = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1NTY3Nzk0NTB9.'
    b = 'kF0VyQtPNpYZ8B5uLMuAPcq2gkzWA6JtpOwJgQTk8Cs'

    "#{a}#{b}"
  end

  let(:params) { { employee: { id: 13, role: 'administrator' } } }

  describe 'POST change_role' do
    before do
      VCR.use_cassette('auth_login_valid_token') do
        VCR.use_cassette('accounts_get_success') do
          VCR.use_cassette('company_find') do
            VCR.use_cassette('company_change_roles') do
              post change_role_api_company_members_url('discipline-success'),
                   params: params,
                   headers: {
                     'Authorization': "Token #{token}"
                   }, as: :json
            end
          end
        end
      end
    end

    it 'responds with success' do
      expect(response).to have_http_status(:success)
    end

    it 'fetches a membership hash' do
      expect(json.keys).to contain_exactly(
        :company, :user, :created_at, :role
      )
    end

    it 'changes the role of the user' do
      expect(json[:role]).to eq('administrator')
    end
  end
end
