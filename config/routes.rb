Rails.application.routes.draw do
  resources :units
  resources :foods
  resources :boxes do
    collection do
      get :owns
      get :invited
    end

    member do
      get :units
      post :invite
      delete 'invite' => :deinvite
    end
  end
  resources :users do
    collection do
      get :verify
      get :search
    end
  end

  post 'auth/local', to: 'authentication#local'
  get 'auth/google/callback', to: 'authentication#google'
end
