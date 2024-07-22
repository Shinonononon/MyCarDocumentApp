Rails.application.routes.draw do
  resources :driver_licenses, only: [:new, :create, :edit, :update]
  resources :vehicle_inspections, only: [:new, :create, :edit, :update]
  resources :compulsory_insurances, only: [:new, :create, :edit, :update]
  resources :optional_insurances, only: [:new, :create, :edit, :update]
  resources :documents, only: [:index]
  # メインページ
  root 'documents#index'
end
