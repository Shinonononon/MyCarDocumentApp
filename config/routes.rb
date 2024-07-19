Rails.application.routes.draw do
  get 'voluntary_insurances/new'
  get 'voluntary_insurances/create'
  get 'voluntary_insurances/edit'
  get 'voluntary_insurances/update'
  get 'compulsory_insurances/new'
  get 'compulsory_insurances/create'
  get 'compulsory_insurances/edit'
  get 'compulsory_insurances/update'
  get 'vehicle_inspections/new'
  get 'vehicle_inspections/create'
  get 'vehicle_inspections/edit'
  get 'vehicle_inspections/update'
  get 'driver_licenses/new'
  get 'driver_licenses/create'
  get 'driver_licenses/edit'
  get 'driver_licenses/update'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
