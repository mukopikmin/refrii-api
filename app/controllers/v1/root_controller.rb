# frozen_string_literal: true

module V1
  class RootController < V1::ApplicationController
    # GET /
    def index
      @content = {
        name: 'Refrii API'
      }
      render json: @content
    end
  end
end
