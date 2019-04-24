module PdvAuthApi
  module Api
    class RegistrationsController < ApiController
      skip_before_action :authenticate_request

      def create
        registration = PdvAuthApi::V1::Registration.new(
          email: registration_params[:email],
          password: registration_params[:password],
          password_confirmation: registration_params[:password_confirmation]
        )

        if registration.save!
          render json: registration.user, status: :ok
        else
          render json: { errors: registration.errors },
                 status: :unprocessable_entity
        end
      end

      private

      def registration_params
        params.require(:registration).permit(
          :email, :password, :password_confirmation
        )
      end
    end
  end
end
