require 'rails_helper'

describe 'GET api/companies' do
  let(:token) do
    a = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozNDgsImV4cCI6MTYwNDQ4MTk5MH0.'
    b = 'IJEBZ253peGgTpoUUwg7hHB0RTKtpCPdQUtBq4YmPKs'

    "#{a}#{b}"
  end

  context 'auth role is member' do
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

  context 'auth role is moderator' do
    before do
      VCR.use_cassette('auth_login_valid_token') do
        VCR.use_cassette('accounts_get_success_moderator') do
          VCR.use_cassette('moderating_apps_all') do
            VCR.use_cassette('subscribers_all') do
              get api_companies_url, headers: {
                'Authorization': "Token #{token}"
                }, as: :json
            end
          end
        end
      end
    end

    describe 'GET index' do
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns a company hash' do
        puts json
        expect(json.first.keys).to contain_exactly(
          :name, :slug, :created_at, :disabled_at
        )
      end
    end
  end
end
