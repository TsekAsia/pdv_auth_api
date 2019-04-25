require 'rails_helper'

describe PdvAuthApi::V1::Company do
  let(:token) do
    a = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1NTY3Nzk0NTB9.'
    b = 'kF0VyQtPNpYZ8B5uLMuAPcq2gkzWA6JtpOwJgQTk8Cs'

    "#{a}#{b}"
  end

  let(:account) do
    VCR.use_cassette('accounts_get_success') do
      PdvAuthApi::V1::Account.new(token: token).fetch
    end
  end

  let(:company) { PdvAuthApi::V1::Company.new(user: account) }

  describe '#create' do
    before do
      create_params = { name: 'ZZYZX', slug: 'zzyzx' }

      VCR.use_cassette('company_create') do
        @response = company.create(create_params)
      end
    end

    it 'reponds with success' do
      expect(@response.response.status).to eq(200)
    end

    it 'assigns a company hash' do
      expect(@response.company.keys).to contain_exactly(
        :name, :slug, :created_at
      )
    end

    it 'returns the company object' do
      expect(@response).to be_a(PdvAuthApi::V1::Company)
    end

    it 'assigns attributes' do
      expect(@response.name).to eq(create_params[:name])
      expect(@response.slug).to eq(create_params[:slug])
      expect(@response.created_at).to eq(company.company[:created_at])
    end
  end

  describe '#all' do
    before do
      VCR.use_cassette('company_all') do
        @response = company.all
      end
    end

    it 'responds with success' do
      expect(@response.response.status).to eq(200)
    end

    it 'fetches an array of companies' do
      expect(@response.size).to eq(1)
    end

    it 'returns a company hash in array' do
      expect(@response.first.keys).to contain_exactly(
        :name, :slug, :created_at
      )
    end
  end

  describe '#find' do
    before do
      VCR.use_cassette('company_find') do
        @response = company.find('zzyzx')
      end
    end

    it 'responds with success' do
      expect(@response.response.status).to eq(200)
    end

    it 'returns a company object' do
      expect(@response).to be_a(PdvAuthApi::V1::Company)
    end

    it 'assigns a company hash' do
      expect(@response.company.keys).to contain_exactly(
        :name, :slug, :created_at
      )
    end

    it 'assigns attributes' do
      expect(@response.name).to eq(company.company[:name])
      expect(@response.slug).to eq(company.company[:slug])
      expect(@response.created_at).to eq(company.company[:created_at])
    end
  end

  describe '#update' do
  end

  describe '#membership' do
  end

  describe '#add_members' do
  end

  describe '#members' do
  end

  describe '#change_role' do
  end
end
