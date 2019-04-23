Rails.application.routes.draw do
  mount PdvAuthApi::Engine => "/pdv_auth_api"
end
