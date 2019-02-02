Rails.application.routes.draw do
  devise_for :users ,controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  authenticated :user do
    root to: 'playlist_cleaners#index'
  end
  root to: 'pages#home'
  resources :playlist_cleaners, only: %w[index show create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
