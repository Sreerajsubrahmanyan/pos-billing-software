Rails.application.routes.draw do
  root "rails/health#show"
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    post "login", to: "auth#login"

    resources :products, only: [
      :index, :show, :create, :update, :destroy
    ]

    resources :staff, only: [
      :index, :show, :create, :update, :destroy
    ]

    resources :sales, only: [:index, :show, :create]
    resources :suppliers, only: [:index, :show, :create, :update, :destroy]
    resources :returns, only: [:index, :create]
    get "ledger", to: "ledger#index"
    get "reports", to: "reports#index"
  end
end
