class RootController < ApplicationController
  # GET /
  def index
    @content = {
      name: 'Refrii API'
    }
    render json: @content
  end
end
