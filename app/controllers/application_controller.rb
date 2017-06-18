class ApplicationController < ActionController::API
  attr_reader :current_user

  protected

  def authenticate_request!
    unless user_id_in_token?
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
      return
    end
    @current_user = User.find(auth_token[:user_id])
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  private

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

  def unauthorized_entity(entity_name)
    render json: ['Unauthorized'], status: :unauthorized
  end

  def forbidden
    render json: ['Forbidden'], status: :forbidden
  end

  def bad_request
    render json: ['Bad request'], status: :bad_request
  end

  def not_modified
    render json: ['Not modified'], status: :not_modified
  end

  def not_found
    render json: ['Not found'], status: :not_found
  end

  def bad_request
    render json: ['Bad request'], status: :bad_request
  end
end
