class V1::RootController < V1::ApplicationController
  # GET /
  def index
    @content = {
      name: 'Refrii API'
    }
    render json: @content
  end
end
