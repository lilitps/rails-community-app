Rails.application.routes.draw do
  get 'posts_controller/edit'

  get 'posts_controller/update'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Use an optional locale in path scope
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get     '/posts',     to: 'static_pages#home'
    get     '/feed',      to: 'static_pages#home'
    get     '/about',     to: 'static_pages#about'
    get     '/contact',   to: 'static_pages#contact'
    get     '/help',      to: 'static_pages#help'

    get     '/signup',    to: 'users#new'
    post    '/signup',    to: 'users#create'

    get     '/login',     to: 'sessions#new'
    post    '/login',     to: 'sessions#create'
    delete  '/logout',    to: 'sessions#destroy'

    post    '/locale',    to: 'locales#update'

    resources :users do
      member do
        get :following, :followers
      end
    end
    resources :account_activations, only: [:edit]
    resources :password_resets,     only: [:new, :create, :edit, :update]
    resources :posts,               only: [:create, :edit, :update, :destroy]
    resources :relationships,       only: [:create, :destroy]

    root    'static_pages#home'
  end

end
