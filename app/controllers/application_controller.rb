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

  def unauthorized(message=nil)
    error = {
      error: 'Not authenticated',
      message: message || 'This action needs authorization.'
    }
    render json: error, status: :unauthorized
  end

  def not_found(message=nil)
    error = {
      error: 'Not found',
      message: message || 'Resource not found.'
    }
    render json: error, status: :not_found
  end

  def bad_request(message=nil)
    error = {
      error: 'Bad request',
      message: message || 'Unexpected error has occured.'
    }
    render json: error, status: :bad_request
  end
end
