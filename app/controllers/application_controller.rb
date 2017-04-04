class ApplicationController < ActionController::API
  include Knock::Authenticable

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
end
