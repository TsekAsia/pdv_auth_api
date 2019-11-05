module PdvAuthApi
  module V1
    class Company
      attr_accessor :company, :response, :name, :slug, :created_at,
                    :account, :errors, :membership_hash, :disabled_at

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
        if account.role == 'moderator'
          return fetch_subscribers if @errors.nil?
        else
          @response = if account.role == 'super_admin'
                        authenticated_api.get 'admin/companies'
                      else
                        authenticated_api.get 'companies'
                      end

          body = JSON.parse(@response.body, symbolize_names: true)

          status_200? body
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

        status_200? body
      end

      def add_members(emails)
        params = { members: { emails: emails } }.to_json

        @response = authenticated_api.post(
          "companies/#{slug}/add_members", params
        )
        body = JSON.parse(@response.body, symbolize_names: true)

        status_200? body
      end

      def members
        @response = authenticated_api.get "companies/#{slug}/members"
        body = JSON.parse(@response.body, symbolize_names: true)

        status_200? body
      end

      def change_role(**params)
        params = {
          membership: {
            user_id: params[:id],
            role: params[:role]
          }
        }.to_json

        @response = authenticated_api.patch(
          "companies/#{slug}/change_role", params
        )
        body = JSON.parse(@response.body, symbolize_names: true)

        status_200? body
      end

      private

      def authenticated_api
        PdvAuthApi::Connection.new(token: account.token).api
      end

      def assign_attributes(params)
        params.each { |key, attr| send(:"#{key}=", attr) }
      end

      def fetch_subscribers
        current_app = PdvAuthApi::V1::App.my_app

        all_companies = []

        account.moderatorships.each do |app|
          next unless current_app[:id] == app[:id]

          @response = authenticated_api
                      .get "apps/#{app[:id]}/subscriptions"

          subscribers = JSON.parse(@response.body, symbolize_names: true)

          return '[]' if subscribers.empty?

          all_companies = format_subscribers_to_companies(subscribers)

          break
        end
        all_companies
      end

      def format_subscribers_to_companies(subscribers)
        companies = []

        subscribers.each do |subscribing|
          companies << subscribing[:company]
        end

        companies.to_json
      end

      def status_200?(body)
        return body if @response.status == 200

        @errors = body.error
        false
      end
    end
  end
end
