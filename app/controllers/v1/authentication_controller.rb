# frozen_string_literal: true

module V1
  class AuthenticationController < V1::ApplicationController
    # POST /auth/local
    def local
      @user = User.find_for_database_authentication(email: params[:email], provider: 'local')

      if @user.valid_password?(params[:password])
        render json: JsonWebToken.payload(@user)
      else
        unauthorized('Invalid username or password is given.')
      end
    end

    # GET /auth/google/callback
    def google
      @user = User.find_for_google(request.env['omniauth.auth'])

      if @user.persisted?
        render json: JsonWebToken.payload(@user)
      else
        unauthorized('Invalid username or password is given.')
      end
    end

    # GET /auth/google/token
    def google_token
      @user = User.find_for_google_token(params[:token])
      render json: JsonWebToken.payload(@user)
    rescue StandardError
      bad_request('Invalid token is given.')
    end

    # GET /auth/auth0/callback
    def auth0
      @user = User.find_for_auth0(request.env['omniauth.auth'])

      if @user.persisted?
        render json: JsonWebToken.payload(@user)
      else
        unauthorized('Invalid username or password is given.')
      end
    end

    # GET /auth/failure
    def failure
      internal_server_error
    end
  end
end
