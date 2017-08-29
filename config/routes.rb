Rails.application.routes.draw do
  resources :units

  resources :foods do
    member do
      get :image
    end
  end

  resources :boxes do
    collection do
      get :owns
      get :invited
    end

    member do
      get :units
      get :image
      post :invite
      delete 'invite' => :deinvite
    end
  end

  resources :users do
    collection do
      get :verify
      get :search
    end

    member do
      get :avatar
    end
  end

  post 'auth/local', to: 'authentication#local'
  get 'auth/google/callback', to: 'authentication#google'
  get 'auth/google/token', to: 'authentication#google_token'
  get 'auth/auth0/callback', to: 'authentication#auth0'
  get 'auth/failure', to: 'authentication#failure'
end
