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
        resources :shop_plans, only: %i[index create]
        resources :versions, only: %i[index create]
      end
    end

    resources :notices, only: %i[destroy]

    resources :boxes do
      scope module: :boxes do
        resources :invitations, only: %i[create]
        resources :versions, only: %i[index create]
        resources :foods, only: %i[index]
        resources :units, only: %i[index]
      end
    end

    resources :invitations, only: %i[destroy]

    resources :users do
      collection do
        get :verify
        get :search
        post 'google' => :create_with_google
      end

      scope module: :users do
        resources :push_tokens, only: %i[create]
      end
    end

    resources :shop_plans
  end
end
