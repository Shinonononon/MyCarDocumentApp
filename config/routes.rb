Rails.application.routes.draw do
  namespace :super_admin do
    resources :employees
  end
  namespace :admin do
    resources :employees
  end
  namespace :department_admin do
    resources :employees, only: [:index, :show]
  end

  devise_for :employees, controllers: {
  confirmations: 'employees/confirmations',
  passwords: 'employees/passwords',
  registrations: 'employees/registrations',
  sessions: 'employees/sessions',
  unlocks: 'employees/unlocks',
  # omniauth_callbacks: 'employees/omniauth_callbacks'
}
  devise_scope :employee do
    get '/employees/sign_out' => 'devise/sessions#destroy'
  end

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

  root to: "pages#index"
  resources :employees, only: [:edit, :update, :show]
  resources :departments


  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

end
