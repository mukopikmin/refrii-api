class UnitsController < ApplicationController
  before_action :set_unit, only: [:show, :update, :destroy]

  # GET /units
  def index
    @units = Unit.owned_by(current_user)

    render json: @units
  end

  # GET /units/1
  def show
    if @unit.is_owned_by(current_user)
      render json: @unit
    else
      not_found
    end
  end

  # POST /units
  def create
    @unit = Unit.new(unit_params)

    if @unit.save
      render json: @unit, status: :created, location: @unit
    else
      render json: @unit.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /units/1
  def update
    if @unit.is_owned_by(current_user)
      if @unit.update(unit_params)
        render json: @unit
      else
        render json: @unit.errors, status: :unprocessable_entity
      end
    else
      bad_request
    end
  end

  # DELETE /units/1
  def destroy
    if @unit.is_owned_by(current_user)
      @unit.destroy
    else
      bad_request
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def unit_params
      params[:user_id] = current_user.id
      params.permit(:label, :step, :user_id)
    end
end
