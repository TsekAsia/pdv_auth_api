module PdvAuthApi
  module Api
    class MembersController < ApiController
      before_action :set_company

      def index
        render json: @company.members
      end

      def batch
        members = @company.add_members(batch_params)

        if members
          render json: members, status: :ok
        else
          render json: { errors: @company.erorrs },
                 status: :unprocessable_entity
        end
      end

      private

      def set_company
        @company.find(slug: params[:company_id])
      end

      def batch_params
        params.require(:members).permit(emails: []).to_hash.symbolize_keys
      end
    end
  end
end
