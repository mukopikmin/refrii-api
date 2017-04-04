Rails.application.routes.draw do
  get 'boxes/owned' => 'boxes#owned'
  get 'boxes/invited' => 'boxes#invited'
  resources :units
  resources :foods
  resources :boxes
  resources :users
  post 'user_token' => 'user_token#create'
  get 'verify' => 'users#verify'
  post 'boxes/:id/invite' => 'boxes#invite'
  delete 'boxes/:id/deinvite' => 'boxes#deinvite'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
