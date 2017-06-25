class ApplicationController < ActionController::API
  attr_reader :current_user

  protected

  def authenticate_request!
    unless user_id_in_token? && token_not_expired?
      unauthorized
      return
    end
    @current_user = User.find(auth_token[:user_id])
  rescue JWT::VerificationError, JWT::DecodeError
    unauthorized
  end

  protected

  def http_token
    @http_token ||= if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end

  def token_not_expired?
    Time.zone.parse(auth_token[:expires_at]) > Time.zone.now
  end

  def unauthorized
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  # def forbidden
  #   render json: ['Forbidden'], status: :forbidden
  # end

  # def not_modified
  #   render json: ['Not modified'], status: :not_modified
  # end

  def not_found
    render json: ['Not found'], status: :not_found
  end

  def bad_request
    render json: ['Bad request'], status: :bad_request
  end

  # def unprocessable_entity
  #   render json: ['Unprocessable entity'], status: :unprocessable_entity
  # end
end
