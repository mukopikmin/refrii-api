# frozen_string_literal: true

class V1::Boxes::UnitsController < V1::ApplicationController
  before_action :authenticate_request!
  before_action :set_box

  # GET /boxes/1/units
  def index
    @units = @box.owner.units

    if !accessible?
      not_found('Specified box does not exist.')
    else
      render json: @units
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_box
    @box = Box.find(params[:box_id])
  end

  def accessible?
    @box.accessible_for?(current_user)
  end
end
