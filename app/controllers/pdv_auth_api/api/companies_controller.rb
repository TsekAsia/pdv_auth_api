module PdvAuthApi
  module Api
    class CompaniesController < ApiController
      def index
        companies = @company.all

        render json: companies, status: :ok
      end

      def show
        company = @company.find(slug: params[:id])

        render json: company.company, status: :ok
      end

      def create
        company_params = create_params.to_hash.symbolize_keys

        company = @company.create(company_params)

        if company
          render json: company.company, status: :ok
        else
          render json: { errors: company.errors }, status: :unprocessable_entity
        end
      end

      private

      def create_params
        params.require(:company).permit(:name, :slug)
      end
    end
  end
end
