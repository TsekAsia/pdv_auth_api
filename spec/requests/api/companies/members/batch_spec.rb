require 'rails_helper'

describe 'POST api/companies/:id/members/batch' do
  let(:token) do
    a = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1NTY3Nzk0NTB9.'
    b = 'kF0VyQtPNpYZ8B5uLMuAPcq2gkzWA6JtpOwJgQTk8Cs'

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
            post api_company_members_url('discipline-success'),
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
      expect(json[:members].size).to eq(4)
    end

    it 'array has a user hash' do
      expect(json[:members].first.keys).to contain_exactly(
        :id, :first_name, :last_name, :middle_name, :username, :email,
        :created_at, :updated_at
      )
    end
  end
end
