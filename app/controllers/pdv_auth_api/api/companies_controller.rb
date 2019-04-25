module PdvAuthApi
  module Api
    class CompaniesController < ApiController
      def index
        companies = PdvAuthApi::V1::Company.new(account: @current_user).all

        render json: companies, status: :ok
      end
    end
  end
end
