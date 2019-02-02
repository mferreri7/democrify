Rails.application.routes.draw do
  devise_for :users ,controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    authenticated :user do
      root 'playlist_cleaners#index'
    end

    unauthenticated do
      root 'devise/sessions#new'
    end
  end
  resources :playlist_cleaners, only: %w[index show create]
end
