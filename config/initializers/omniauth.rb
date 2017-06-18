Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           ENV['GOOGLE_CLIENT_ID'],
           ENV['GOOGLE_CLIENT_SECRET'],
           name: 'google',
           redirect_uri: ENV['GOOGLE_CALLBACK_URL'],
           :provider_ignores_state => true,
           client_options: {
             ssl: {
               ca_file: '/usr/lib/ssl/certs/ca-certificates.crt'
             }
           }
end
