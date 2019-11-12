module PdvAuthApi
  module Api
    module Concerns
      module Permissions
        def permitted(role)
          if @current_user.permit?(role: role, current_user: @current_user)
            self
          else
            @errors = @current_user.errors

            render json: { errors: @errors }, status: :unauthorized
          end
        end
      end
    end
  end
end