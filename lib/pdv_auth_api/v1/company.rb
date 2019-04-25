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
