module PdvAuthApi
  module Api
    class CompaniesController < ApiController
      before_action :set_company, only: %i[show update]

      def index
        companies = @company.all

        render json: companies, status: :ok
      end

      def show
        render json: @company.company, status: :ok
      end

      def create
        if @company.create(company_params)
          render json: @company.company, status: :ok
        else
          render json: { errors: @company.errors },
                 status: :unprocessable_entity
        end
      end

      def update
        if @company.update(company_params)
          render json: @company.company, status: :ok
        else
          render json: { errors: @company.errors },
                 status: :unprocessable_entity
        end
      end

      private

      def company_params
        params.require(:company).permit(:name, :slug).to_hash.symbolize_keys
      end

      def set_company
        @company.find(slug: params[:id])
      end
    end
  end
end
