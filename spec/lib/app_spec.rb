require 'rails_helper'

describe PdvAuthApi::V1::App do
  let(:email) { 'test@testmail.dev' }
  let(:password) { 'thisisthepassword' }
  let(:account) { PdvAuthApi::V1::Account.new }
  let(:app_id) { 1 }

  describe 'find' do
    before do
      VCR.use_cassette('auth_login_valid_login') do
        VCR.use_cassette('app_find_success') do
          PdvAuthApi::V1::App.find(id: app_id)
        end
      end
    end
  end
end
