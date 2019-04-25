module PdvAuthApi
  module V1
    class Account
      attr_accessor :token, :user, :response, :errors,
                    :id, :first_name, :middle_name, :last_name, :email,
                    :created_at, :updated_at, :username

      EDITABLE_ATTRIBUTES = %i[
        first_name middle_name last_name email username
      ].freeze

      def initialize(**params)
        assign_attributes(params)
      end

      def fetch(**params)
        assign_attributes(params)

        @response = authenticated_api.get 'account'

        body = JSON.parse(@response.body, symbolize_names: true)

        if @response.status == 200
          assign_attributes(body)
          @user = body
          self
        else
          @errors = body[:errors]
          false
        end
      end

      def update(**params)
        sanitized_params = {
          user: params.select { |key, _val| EDITABLE_ATTRIBUTES.include?(key) }
        }.to_json

        @response = authenticated_api.patch 'account', sanitized_params
        body = JSON.parse(@response.body, symbolize_names: true)

        if @response.status == 200
          assign_attributes(body)
          @user = body
          self
        else
          @errors = body.errors
          false
        end
      end

      def save
        new_attrs = {}

        EDITABLE_ATTRIBUTES.each do |key|
          send(key) != user[:"#{key}"] ? new_attrs[:"#{key}"] = send(key) : nil
        end

        update(new_attrs)
      end

      def authenticated_api
        PdvAuthApi::Connection.new(token: @token).api
      end

      private

      def assign_attributes(params)
        params.each { |key, attr| send(:"#{key}=", attr) }
      end
    end
  end
end
