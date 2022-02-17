Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:create, :index, :show, :update]
  resources :measurement_history, only: [:index]
  resources :monthly_report, only: [:index]
  get 'dashboard/weekly_measure', controller: 'dashboard', action: 'weekly_measure'
  get 'dashboard/last_measure', controller: 'dashboard', action: 'last_measure'
end
