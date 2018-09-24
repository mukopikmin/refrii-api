# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           ENV['GOOGLE_CLIENT_ID'],
           ENV['GOOGLE_CLIENT_SECRET'],
           name: 'google',
           redirect_uri: ENV['GOOGLE_CALLBACK_URL'],
           provider_ignores_state: true
  provider :auth0,
           ENV['AUTH0_CLIENT_ID'],
           ENV['AUTH0_CLIENT_SECRET'],
           ENV['AUTH0_DOMAIN'],
           redirect_uri: ENV['GOOGLE_CALLBACK_URL'],
           provider_ignores_state: true
end
