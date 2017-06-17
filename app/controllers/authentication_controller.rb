class AuthenticationController < ApplicationController

  # POST /auth/local
  def local
    user = User.find_for_database_authentication(email: params[:email])

    if user.valid_password?(params[:password])
      render json: payload(user)
    else
      render json: { errors: ['Invalid Username/Password'] }, status: :unauthorized
    end
  end

  private

  def payload(user)
    return nil unless user && user.id
    {
      jwt: JsonWebToken.encode(user_id: user.id,
                               expires_at: 3.days.since),
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        expires_at: 3.days.since
      }
    }
  end
end
