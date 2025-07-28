Rails.application.routes.draw do
  get "credit_cards/index"
  get "credit_cards/show"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  resource :sessions, only: %i[new create destroy]

  resources :splits do
    member do
      patch :mark_as_paid
    end
  end

  resources :transfers, except: :show
  resources :transactions, except: :show do
    resource :split, controller: "transactions/splits", only: [:show, :new, :create, :edit, :update, :destroy]
  end
  resources :accounts do
    resource :balance_fix, only: [:new, :create], controller: "accounts/balance_fixes"
  end
  resources :credit_cards, only: [:index, :show] do
    resource :statement_payment, only: [:new, :create], controller: "credit_cards/statement_payments"
  end
  resources :categories, except: :show

  resources :similar_transactions, only: [:index]

  resource :settings, only: :show
  namespace :settings do
    resource :export_data, only: :create
    resource :import_data, only: :create
  end

  resource :reports, only: :show
  namespace :reports do
    resource :daily_balance, only: :show
    resource :income_by_category, only: :show
    resource :expenses_by_category, only: :show
  end
end
