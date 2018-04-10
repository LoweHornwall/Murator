Rails.application.routes.draw do
  get 'release_groups/search'
  root 'static_pages#home'
  get 'static_pages/about', to: 'static_pages#about'
  resources :users,               only: [:show, :new, :create] do
    member do
      get :followed
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :curation_pages,      only: [:index, :show, :new, :create] do
    resources :reviews, only: [:show, :new, :create]
    member do
      get :followers
    end 
  end
  resources :page_followings, only: [:create, :destroy]
  get '/login',      to: 'sessions#new'
  post '/login',     to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end
