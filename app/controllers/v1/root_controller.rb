# frozen_string_literal: true

module V1
  class RootController < V1::ApplicationController
    # GET /
    def index
      @content = {
        name: 'Refrii API',
        version: ENV['RELEASE_TAG'],
        build_hash: ENV['RELEASE_HASH']
      }
      render json: @content
    end
  end
end
