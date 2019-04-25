require 'rails_helper'

describe PdvAuthApi::V1::Company do
  let(:token) do
    a = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1NTY3Nzk0NTB9.'
    b = 'kF0VyQtPNpYZ8B5uLMuAPcq2gkzWA6JtpOwJgQTk8Cs'

    "#{a}#{b}"
  end

  let(:company) { PdvAuthApi::V1::Company.new }

  describe '#create' do
    before do
      @create_params = { name: 'ZZYZX', slug: 'zzyzx' }

      VCR.use_cassette('accounts_get_success') do
        VCR.use_cassette('company_create') do
          company.account = PdvAuthApi::V1::Account.new(token: token).fetch

          @response = company.create(@create_params)
        end
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
      expect(@response.name).to eq(@create_params[:name])
      expect(@response.slug).to eq(@create_params[:slug])
      expect(@response.created_at).to eq(company.company[:created_at])
    end
  end

  describe '#all' do
    before do
      VCR.use_cassette('accounts_get_success') do
        VCR.use_cassette('company_all') do
          company.account = PdvAuthApi::V1::Account.new(token: token).fetch

          @response = company.all
        end
      end
    end

    it 'responds with success' do
      expect(company.response.status).to eq(200)
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
      VCR.use_cassette('accounts_get_success') do
        VCR.use_cassette('company_find') do
          company.account = PdvAuthApi::V1::Account.new(token: token).fetch

          @response = company.find(slug: 'zzyzx')
        end
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
    before do
      @update_params = {
        name: 'xzyzz',
        slug: 'xzyzz'
      }

      VCR.use_cassette('accounts_get_success') do
        VCR.use_cassette('company_find') do
          VCR.use_cassette('company_update') do
            company.account = PdvAuthApi::V1::Account.new(token: token)
                                                     .fetch

            company.find(slug: 'zzyzx')

            @response = company.update(@update_params)
          end
        end
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

  describe '#save' do
    before do
      VCR.use_cassette('accounts_get_success') do
        VCR.use_cassette('company_find') do
          VCR.use_cassette('company_save') do
            company.account = PdvAuthApi::V1::Account.new(token: token)
                                                     .fetch

            company.find(slug: 'xzyzz')

            company.name = 'Discipline to Success'
            company.slug = 'discipline-success'

            @response = company.save
          end
        end
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

  describe '#membership' do
    before do
      VCR.use_cassette('accounts_get_success') do
        VCR.use_cassette('company_find') do
          VCR.use_cassette('company_membership') do
            company.account = PdvAuthApi::V1::Account.new(token: token)
                                                     .fetch

            company.find(slug: 'discipline-success')

            @response = company.membership
          end
        end
      end
    end

    it 'responds with success' do
      expect(company.response.status).to eq(200)
    end

    it 'fetches a membership hash' do
      expect(@response.keys).to contain_exactly(
        :company, :user, :created_at, :role
      )
    end
  end

  describe '#add_members' do
    before do
      @emails = [
        'thorodinson@asgardianmail.com',
        'tony@starkindustries.com',
        'steverogers@aol.com',
        'brucebanner@culver.edu'
      ]

      VCR.use_cassette('accounts_get_success') do
        VCR.use_cassette('company_find') do
          VCR.use_cassette('company_add_members') do
            company.account = PdvAuthApi::V1::Account.new(token: token)
                                                     .fetch

            company.find(slug: 'discipline-success')

            @response = company.add_members(@emails)
          end
        end
      end
    end

    it 'responds with success' do
      expect(company.response.status).to eq(200)
    end

    it 'fetches an array of users' do
      expect(@response.size).to eq(@emails.size)
    end

    it 'array has a user hash' do
      expect(@response.first.keys).to contain_exactly(
        :id, :first_name, :last_name, :middle_name, :username, :email,
        :created_at, :updated_at
      )
    end
  end

  describe '#members' do
    before do
      VCR.use_cassette('accounts_get_success') do
        VCR.use_cassette('company_find') do
          VCR.use_cassette('company_members') do
            company.account = PdvAuthApi::V1::Account.new(token: token)
                                                     .fetch

            company.find(slug: 'discipline-success')

            @response = company.members
          end
        end
      end
    end

    it 'responds with success' do
      expect(company.response.status).to eq(200)
    end

    it 'fetches an array of members' do
      expect(@response.size).to eq(5)
    end

    it 'array has a user hash' do
      expect(@response.first.keys).to contain_exactly(
        :id, :first_name, :last_name, :middle_name, :username, :email,
        :created_at, :updated_at
      )
    end
  end

  describe '#change_role' do
    before do
      @change_role_params = {
        id: 13,
        role: 'administrator'
      }

      VCR.use_cassette('accounts_get_success') do
        VCR.use_cassette('company_find') do
          VCR.use_cassette('company_change_roles') do
            company.account = PdvAuthApi::V1::Account.new(token: token)
                                                     .fetch

            company.find(slug: 'discipline-success')

            @response = company.change_role(@change_role_params)
          end
        end
      end
    end

    it 'responds with success' do
      expect(company.response.status).to eq(200)
    end

    it 'fetches a membership hash' do
      expect(@response.keys).to contain_exactly(
        :company, :user, :created_at, :role
      )
    end

    it 'changes the role of the user' do
      expect(@response[:role]).to eq('administrator')
    end
  end
end
