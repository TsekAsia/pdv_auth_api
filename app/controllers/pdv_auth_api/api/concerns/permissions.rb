module PdvAuthApi
  module Api
    module Concerns
      module Permissions
        def permitted?(role)
          params = {
            permit: {
              user_id: @current_user.id,
              role: role
            }
          }.to_json

          @response = authenticated_api.post('permits', params)

          body = JSON.parse(@response.body, symbolize_names: true)

          if @response.status == :ok
            true
          else
            @errors = body.errors

            render json: { errors: @errors }, status: :unauthorized
          end
        end

        private

        def authenticated_api
          PdvAuthApi::Connection.new(token: @token).api
        end
      end
    end
  end
end
