Rails.application.routes.draw do
  root 'static_pages#home'
  resources :users,  only: [:new, :create]
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  get '/login',      to: 'sessions#new'
  post '/login',     to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
