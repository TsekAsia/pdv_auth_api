require 'rails_helper'

describe 'POST api/companies/:id/members/batch' do
  let(:token) do
    a = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0MTksImV4cCI6MTYwMzMzMzczNH0.'
    b = 'O2aa8KBvwRkQ-Zi84P7rkt9_0lm7gZnX_XWghmE7ZaQ'

    "#{a}#{b}"
  end
  let(:emails) do
    [
      'thorodinson@asgardianmail.com',
      'tony@starkindustries.com',
      'steverogers@aol.com',
      'brucebanner@culver.edu'
    ]
  end

  let(:params) { { members: { emails: emails } } }

  before do
    VCR.use_cassette('auth_login_valid_token') do
      VCR.use_cassette('accounts_get_success') do
        VCR.use_cassette('company_find') do
          VCR.use_cassette('company_add_members') do
            post batch_api_company_members_url('discipline-success'),
                 params: params,
                 headers: {
                   'Authorization': "Token #{token}"
                 }, as: :json
          end
        end
      end
    end
  end

  describe 'POST batch' do
    it 'responds with success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns an array of users' do
      expect(json.size).to eq(4)
    end

    it 'array has a user hash' do
      expect(json.first.keys).to contain_exactly(
        :id, :first_name, :last_name, :middle_name, :username, :email,
        :created_at, :updated_at, :disabled_at, :membership,
        :require_password_reset, :role
      )
    end
  end
end
