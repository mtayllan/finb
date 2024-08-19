Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  resource :sessions, only: %i[show create destroy]

  resources :transfers, except: :show
  resources :transactions, except: :show
  resources :accounts
  resources :categories, except: :show

  resources :similar_transactions, only: [:index]

  resource :settings, only: :show
  namespace :settings do
    resource :export_data, only: :create
    resource :import_data, only: :create
  end

  namespace :reports do
    resource :daily_balance, only: :show
    resource :income_by_category, only: :show
    resource :expenses_by_category, only: :show
  end
end
