# frozen_string_literal: true

class V1::Boxes::FoodsController < V1::ApplicationController
  before_action :authenticate_request!
  before_action :set_box

  # GET /boxes/1/foods
  def index
    if !accessible?
      not_found('Specified box does not exist.')
    else
      render json: @box.foods
    end
  end

  private

  def set_box
    @box = Box.find(params[:box_id])
  end

  def accessible?
    @box.accessible_for?(current_user)
  end
end
