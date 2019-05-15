# frozen_string_literal: true

Rails.application.routes.default_url_options = {
  host: Rails.env == 'production' ? 'api.refrii.com' : 'localhost:3000',
  only_path: false,
  protocol: Rails.env == 'production' ? 'https' : 'http'
}

Rails.application.routes.draw do
  api_version(module: 'V1', path: { value: 'v1' }, default: true) do
    root 'root#index'

    resources :units

    resources :foods do
      member do
        get :versions
        get :shop_plans
        put :revert
      end
    end

    resources :boxes do
      collection do
        get :owns
        get :invited
      end

      member do
        get :versions
        get :foods
        get :units
        get :image
        post :invite
        put :revert
        delete 'invite' => :uninvite
      end
    end

    resources :users do
      collection do
        get :verify
        get :search
      end

      member do
        post :push_token
      end
    end

    resources :shop_plans
  end
end
