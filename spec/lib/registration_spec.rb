require 'rails_helper'

describe PdvAuthApi::V1::Registration do
  let(:registration) { PdvAuthApi::V1::Registration.new }

  it 'should exist' do
    expect(registration).to be_kind_of(PdvAuthApi::V1::Registration)
  end

  describe 'new' do
    it 'should respond to email' do
      expect(registration).to respond_to(:email)
      expect(registration).to respond_to(:email=)
    end

    it 'should respond to password' do
      expect(registration).to respond_to(:password)
      expect(registration).to respond_to(:password=)
    end

    it 'should respond to password confirmation' do
      expect(registration).to respond_to(:password_confirmation)
      expect(registration).to respond_to(:password_confirmation=)
    end
  end

  describe '#save!' do
    before do
      VCR.use_cassette('registrations_valid_post') do
        registration.email = 'test@testmail.dev'
        registration.password = 'thisisthepassword'
        registration.password_confirmation = 'thisisthepassword'

        @save_response = registration.save!
      end
    end

    it 'should have a status of success' do
      expect(registration.response.status).to eq(200)
    end

    it 'should return an object of the user' do
      expect(@save_response.keys).to contain_exactly(
        :created_at, :email, :first_name, :middle_name, :last_name, :id,
        :updated_at, :username, :disabled_at, :membership,
        :require_password_reset, :role
      )
    end

    it 'object should have user' do
      expect(registration.user).to eq(@save_response)
    end
  end

  describe '#save! with_errors' do
    before do
      VCR.use_cassette('registrations_with_errors_post') do
        registration.email = 'notanemail'
        registration.password = 'thisisthepassword'
        registration.password_confirmation = 'thisisNOTthepassword'

        @save_response = registration.save!
      end
    end

    it 'should have a status of unprocessable' do
      expect(registration.response.status).to eq(400)
    end

    it 'should return false' do
      expect(@save_response).to eq(false)
    end

    it 'object should have errors' do
      expect(!registration.errors.empty?).to eq(true)
    end

    it 'has error messages' do
      expect(registration.errors.size).to eq(2)
    end

    it 'object errors should not be nil' do
      expect(registration.errors).not_to eq(nil)
    end
  end
end
