class BoxesController < ApplicationController
  before_action :authenticate_user
  before_action :set_box, only: [:show, :update, :destroy]

  # GET /boxes
  def index
    @boxes = Box.all
    render json: @boxes, include: [:owner, { rooms: :foods }]
  end

  # GET /boxes/1
  def show
    render json: @box, include: [:owner, { rooms: :foods }]
  end

  # POST /boxes
  def create
    @box = Box.new(box_params)

    if @box.save
      render json: @box, status: :created, location: @box
    else
      render json: @box.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /boxes/1
  def update
    if @box.update(box_params)
      render json: @box
    else
      render json: @box.errors, status: :unprocessable_entity
    end
  end

  # DELETE /boxes/1
  def destroy
    @box.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_box
    @box = Box.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def box_params
    params.fetch(:box, {})
  end
end
