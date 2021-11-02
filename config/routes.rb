Rails.application.routes.draw do
  resources :client
  resources :seller
  resources :product
  resources :sale
end
