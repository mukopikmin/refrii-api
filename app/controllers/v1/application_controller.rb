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

      @current_user = User.where(email: auth_token['decoded_token'][:payload]['email']).first
    rescue StandardError
      unauthorized
    end

    def http_token
      token = request.headers['Authorization']
      @http_token ||= token.split(' ').last if token.present?
    end

    def auth_token
      @auth_token = FirebaseUtils::Auth.verify_id_token(http_token)
    end

    def user_id_in_token?
      if http_token && auth_token
        payload = auth_token['decoded_token'][:payload]
        email = payload['email']

        if User.exists?(email: email)
          true
        else
          avatar = User.download_image(payload['picture'])
          user = User.new(name: payload['name'],
                          email: email,
                          provider: 'google',
                          password_digest: 'no password',
                          avatar_file: avatar[:file],
                          avatar_size: avatar[:size],
                          avatar_content_type: avatar[:content_type])
          user.save
        end
      else
        false
      end
    end

    def token_not_expired?
      Time.zone.at(auth_token['decoded_token'][:payload]['exp']) > Time.zone.now
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
