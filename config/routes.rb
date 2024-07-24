Rails.application.routes.draw do

  get 'pages/index'
  namespace :uploads do
    resources :driver_licenses, only: [:new, :create, :edit, :update]
    resources :vehicle_inspections, only: [:new, :create, :edit, :update]
    resources :compulsory_insurances, only: [:new, :create, :edit, :update]
    resources :optional_insurances, only: [:new, :create, :edit, :update]
    resources :documents, only: [:index]
  end
  # メインページ
  # root 'documents#index'
  devise_for :employees, controllers: {
  confirmations: 'employees/confirmations',
  passwords: 'employees/passwords',
  registrations: 'employees/registrations',
  sessions: 'employees/sessions',
  unlocks: 'employees/unlocks',
  # omniauth_callbacks: 'employees/omniauth_callbacks'
}
  root to: "pages#index"
  resources :employees
  resources :departments, only: [:index, :new, :create, :destroy]
end
