Rails.application.routes.draw do
  mount PdvAuthApi::Engine => '/'
end
