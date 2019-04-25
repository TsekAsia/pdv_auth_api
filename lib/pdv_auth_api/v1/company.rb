module PdvAuthApi
  module V1
    class Company
      attr_accessor :company, :response, :name, :slug, :created_at,
                    :account, :errors

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
