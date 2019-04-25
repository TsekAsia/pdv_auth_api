module PdvAuthApi
  module V1
    class Company
      attr_accessor :company, :response, :name, :slug, :created_at,
                    :account, :errors, :membership_hash

      EDITABLE_ATTRIBUTES = %i[name slug].freeze

      def initialize(**params)
        assign_attributes(params)
      end

      def create(**params)
        sanitized_params = params.select do |key, _val|
          EDITABLE_ATTRIBUTES.include?(key)
        end

        params = { company: sanitized_params }.to_json

        @response = authenticated_api.post 'companies', params
        body = JSON.parse(@response.body, symbolize_names: true)

        if @response.status == 200
          @company = body
          assign_attributes(body)
          self
        else
          @errors = body[:errors]
          false
        end
      end

      def all
        @response = authenticated_api.get 'companies'

        body = JSON.parse(@response.body, symbolize_names: true)

        if @response.status == 200
          body
        else
          @errors = body.error
          false
        end
      end

      def find(**params)
        assign_attributes(params)

        @response = authenticated_api.get "companies/#{slug}"
        body = JSON.parse(@response.body, symbolize_names: true)

        if @response.status == 200
          @company = body
          assign_attributes(body)
          self
        else
          @errors = body.error
          false
        end
      end

      def update(**params)
        sanitized_params = params.select do |key, _val|
          EDITABLE_ATTRIBUTES.include?(key)
        end

        @response = authenticated_api.patch(
          "companies/#{company[:slug]}", sanitized_params.to_json
        )
        body = JSON.parse(@response.body, symbolize_names: true)

        if @response.status == 200
          @company = body
          assign_attributes(body)
          self
        else
          @errors = body.errors
          false
        end
      end

      def save
        new_attrs = {}

        EDITABLE_ATTRIBUTES.each do |key|
          next unless send(key) != company[:"#{key}"]

          new_attrs[:"#{key}"] = send(key)
        end

        update(new_attrs)
      end

      def membership
        @response = authenticated_api.get "companies/#{slug}/my_membership"
        body = JSON.parse(@response.body, symbolize_names: true)

        if @response.status == 200
          body
        else
          @errors = body.error
          false
        end
      end

      def add_members(emails)
        params = { members: { emails: emails } }.to_json

        @response = authenticated_api.post(
          "companies/#{slug}/add_members", params
        )
        body = JSON.parse(@response.body, symbolize_names: true)

        if @response.status == 200
          body
        else
          @errors = body.errors
          false
        end
      end

      def members
        @response = authenticated_api.get "companies/#{slug}/members"
        body = JSON.parse(@response.body, symbolize_names: true)

        if @response.status == 200
          body
        else
          @errors = body.error
          false
        end
      end

      private

      def authenticated_api
        PdvAuthApi::Connection.new(token: account.token).api
      end

      def assign_attributes(params)
        params.each { |key, attr| send(:"#{key}=", attr) }
      end
    end
  end
end
