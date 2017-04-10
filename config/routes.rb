Rails.application.routes.draw do
  resources :units
  resources :foods
  resources :boxes do
    collection do
      get :owns
      get :invited
    end

    member do
      post :invite
      delete :deinvite
    end
  end
  resources :users do
    collection do
      get :verify
      get :search
    end
  end
  post 'user_token' => 'user_token#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
