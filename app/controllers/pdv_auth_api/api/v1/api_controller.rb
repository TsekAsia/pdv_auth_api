module PdvAuthApi
  module Api
    module V1
      class ApiController < ApplicationController
        def create
        end

        private

        def auth_params
          params.require(:auth).permit(:email, :password)
        end
      end
    end
  end
end
