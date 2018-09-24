# frozen_string_literal: true

module V1
  class ApplicationController < ActionController::API
    attr_reader :current_user

    protected

    def authenticate_request!
      unless user_id_in_token? && token_not_expired?
        unauthorized
        return
      end
      @current_user = User.find(auth_token[:user_id])
    rescue StandardError
      unauthorized
    end

    def http_token
      token = request.headers['Authorization']
      @http_token ||= token.split(' ').last if token.present?
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

    def unauthorized(message = nil)
      render json: HttpError.new(:unauthorized, message), status: :unauthorized
    end

    def not_found(message = nil)
      render json: HttpError.new(:not_found, message), status: :not_found
    end

    def bad_request(message = nil)
      render json: HttpError.new(:bad_request, message), status: :bad_request
    end

    def forbidden(message = nil)
      render json: HttpError.new(:forbidden, message), status: :forbidden
    end

    def internal_server_error(message = nil)
      render json: HttpError.new(:internal_server_error, message), status: :internal_server_error
    end
  end
end
