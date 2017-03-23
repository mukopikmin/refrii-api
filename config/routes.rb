Rails.application.routes.draw do
  resources :foods
  resources :rooms
  resources :boxes
  resources :users
  post 'user_token' => 'user_token#create'
  get 'verify' => 'users#verify'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
