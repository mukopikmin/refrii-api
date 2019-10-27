# frozen_string_literal: true

host = 'localhost:3000'

if Rails.env == 'production'
  host = if ENV['STAGING_ENABLED'] == 'true'
           'staging.api.refrii.com'
         else
           'api.refrii.com'
         end
end

Rails.application.routes.default_url_options = {
  host: host,
  only_path: false,
  protocol: Rails.env == 'production' ? 'https' : 'http'
}

Rails.application.routes.draw do
  api_version(module: 'V1', path: { value: 'v1' }, default: true) do
    root 'root#index'

    resources :units

    resources :foods do
      scope module: :foods do
        resources :notices, only: %i[create]
        resources :shop_plans, only: %i[index]
        resources :versions, only: %i[index create]
      end
    end

    resources :notices, only: %i[destroy]

    resources :boxes do
      collection do
        get :owns
        get :invited
      end

      member do
        get :versions
        get :foods
        get :units
        post :invite
        put :revert
        delete 'invite' => :uninvite
      end
    end

    resources :users do
      collection do
        get :verify
        get :search
        post 'google' => :create_with_google
      end

      member do
        post :push_token
      end
    end

    resources :shop_plans do
      member do
        put :complete
      end
    end
  end
end
