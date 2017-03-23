class ApplicationController < ActionController::API
  include Knock::Authenticable

  def unauthorized_entity(entity_name)
    render json: ["Unauthorized"], status: :unauthorized
  end
end
