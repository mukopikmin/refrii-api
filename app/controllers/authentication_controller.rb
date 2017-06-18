class AuthenticationController < ApplicationController

  # POST /auth/local
  def local
    user = User.find_for_database_authentication(email: params[:email])

    if user.valid_password?(params[:password])
      render json: JsonWebToken.payload(user)
    else
      render json: { errors: ['Invalid Username/Password'] }, status: :unauthorized
    end
  end

  def google
    user = User.find_for_google(request.env['omniauth.auth'])

    if user.persisted?
      render json: JsonWebToken.payload(user)
    else
      render json: { errors: ['Invalid Username/Password'] }, status: :unauthorized
    end
  end
end
