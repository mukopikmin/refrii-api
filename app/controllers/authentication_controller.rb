class AuthenticationController < ApplicationController

  # POST /auth/local
  def local
    @user = User.find_for_database_authentication(email: params[:email])

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
