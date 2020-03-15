# frozen_string_literal: true

class V1::RootController < V1::ApplicationController
  # GET /
  def index
    @content = {
      name: 'Refrii API',
      version: '1.2.3',
      build_hash: ENV['RELEASE_HASH']
    }
    render json: @content
  end
end
