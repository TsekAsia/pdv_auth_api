module PdvAuthApi
  module Api
    module Companies
      class MembersController < ApiController
        before_action :set_company

        def index; end

        def batch; end

        private

        def set_company
          @company.find(params[:company_id])
        end
      end
    end
  end
end
