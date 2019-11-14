# frozen_string_literal: true

class V1::Foods::VersionsController < V1::ApplicationController
  before_action :authenticate_request!
  before_action :set_food, only: %i[index create]

  # GET /foods/1/versions
  def index
    if !accessible?
      not_found
    else
      render json: @food.versions
    end
  end

  # POST /foods/1/versions
  # Create new versions from previous version as current version
  def create
    if !accessible?
      bad_request('You can not revert the food.')
    elsif @food.revert
      render json: @food, status: :created
    else
      bad_request
    end
  end

  private

  def set_food
    @food = Food.find(params[:food_id])
  end

  def accessible?
    @food.box.accessible_for?(current_user)
  end
end
