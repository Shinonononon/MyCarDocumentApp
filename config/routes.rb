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
  get 'help', to: 'pages#help'
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

  # get '*path', to: 'application#render404'
  # get '*path', to: 'application#render500'
  # 上のやつだと、アクティブストレージがパーになって動かないから下のに変更
  # https://qiita.com/xusaku_/items/8c8dc237dbbbcc116964
  get '*not_found' => 'application#render404', constraints: lambda { |request| !request.path.include?("active_storage") }
  post '*not_found' => 'application#render404', constraints: lambda { |request| !request.path.include?("active_storage") }

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

end
