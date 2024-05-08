Rails.application.routes.draw do
  namespace :api do
    resources :users
    resources :companies
    resources :flights
    resources :bookings
    resources :sessions
    post 'session', to: 'sessions#create'
    delete 'session', to: 'sessions#destroy'
    post 'booking', to: 'bookings#create'
    post 'bookings', to: 'bookings#create'
  end
end
