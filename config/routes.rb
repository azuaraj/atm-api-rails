Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Authentication routes
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # Account routes
  get "/accounts/show", to: "accounts#show"
  post "/accounts/deposit", to: "accounts#deposit"
  post "/accounts/withdraw", to: "accounts#withdraw"
end
