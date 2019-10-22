module PdvAuthApi
  module V1
    class Account
      attr_accessor :token, :user, :response, :errors,
                    :id, :first_name, :middle_name, :last_name, :email,
                    :created_at, :updated_at, :username, :membership,
                    :disabled_at, :role, :require_password_reset, :full_name

      EDITABLE_ATTRIBUTES = %i[
        first_name middle_name last_name email username
      ].freeze

      FIND_ATTRIBUTES = %i[id email].freeze

      class << self
        def find(**params)
          sanitized_params = params.select do |key, _val|
            FIND_ATTRIBUTES.include?(key)
          end

          @response = api.post 'account/find', sanitized_params.to_json
          body = JSON.parse(@response.body, symbolize_names: true)

          return nil unless body[:exists]

          new(body[:user])
        end

        private

        def api
          PdvAuthApi::Connection.new.api
        end

        def assign_attributes(params)
          params.each { |key, attr| send(:"#{key}=", attr) }
        end
      end

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

      def change_password(**params)
        change_password_params = {
          user: {
            old_password: params[:old_password],
            password: params[:password],
            password_confirmation: params[:password_confirmation]
          }
        }.to_json

        @response = authenticated_api.patch 'account/change_password',
                                            change_password_params

        body = JSON.parse(@response.body, symbolize_names: true)

        if @response.status == 200
          true
        else
          @errors = body[:errors]
          false
        end
      end

      def permit?(**params)
        current_user = params[:current_user]
        permit_params = {
          permit: {
            user_id: current_user.id,
            role: params[:role]
          }
        }.to_json

        @response = authenticated_api.post 'permits', permit_params

        body = JSON.parse(@response.body, symbolize_names: true)

        if @response.status == 200
          true
        else
          @errors = body[:errors]
          false
        end
      end

      private

      def authenticated_api
        PdvAuthApi::Connection.new(token: @token).api
      end

      def assign_attributes(params)
        params.each { |key, attr| send(:"#{key}=", attr) }
      end
    end
  end
end
