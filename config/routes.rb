# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Use an optional locale in path scope
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    get     '/posts',     to: 'static_pages#home'
    get     '/feed',      to: 'static_pages#home'
    get     '/membership_application', to: 'static_pages#membership_application'
    get     '/about',     to: 'static_pages#about'
    get     '/help',      to: 'static_pages#help'

    get     '/signup',    to: 'users#new'
    post    '/signup',    to: 'users#create'

    get     '/login',     to: 'user_sessions#new'
    post    '/login',     to: 'user_sessions#create'
    delete  '/logout',    to: 'user_sessions#destroy'

    post    '/locale',    to: 'locales#update'

    get     '/contact',   to: 'contacts#new'
    post    '/contact',   to: 'contacts#create'

    resources :users do
      member do
        get :following, :followers
      end
    end
    resources :account_activations, only: [:edit]
    resources :password_resets,     only: %i[new create edit update]
    resources :posts,               only: %i[create edit update destroy]
    resources :relationships,       only: %i[create destroy]

    root 'static_pages#home'
  end
end
