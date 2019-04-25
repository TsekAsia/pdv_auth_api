module PdvAuthApi
  module Api
    class AccountsController < ApiController
      def show
        render json: @current_user.user
      end

      def update
        if @current_user.update(update_params)
          render json: @current_user.user
        else
          render json: { errors: @current_user.errors },
                 status: :unprocessable_entity
        end
      end

      def change_password
        if @current_user.change_password(change_password_params)
          render json: { message: 'Updated password.' }, status: :ok
        else
          render json: { errors: @current_user.errors },
                 status: :unprocessable_entity
        end
      end

      private

      def update_params
        params.require(:user).permit(
          :first_name, :last_name, :middle_name,
          :username, :email
        )
      end

      def change_password_params
        params.require(:user).permit(
          :old_password, :password, :password_confirmation
        )
      end
    end
  end
end
