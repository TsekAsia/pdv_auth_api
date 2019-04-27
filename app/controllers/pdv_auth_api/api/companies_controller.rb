module PdvAuthApi
  module Api
    class CompaniesController < ApiController
      def index
        companies = PdvAuthApi::V1::Company.new(account: @current_user).all

        render json: companies, status: :ok
      end

      def show
        company = PdvAuthApi::V1::Company
                  .new(account: @current_user)
                  .find(slug: params[:id])

        render json: company.company, status: :ok
      end

      def create; end

      private

      def create_params
        params.require(:company).permit(:name, :slug)
      end
    end
  end
end
