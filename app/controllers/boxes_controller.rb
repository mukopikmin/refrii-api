class BoxesController < ApplicationController
  before_action :authenticate_user
  before_action :set_box, only: [:show, :update, :destroy]

  # GET /boxes
  def index
    @boxes = Box.where(owner: current_user, removed: false)
    render json: @boxes, include: [:owner, { rooms: :foods }]
  end

  # GET /boxes/1
  def show
    if @box.is_owned_by(current_user)
      render json: @box, include: [:owner, { rooms: :foods }]
    else
      forbidden
    end
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
    if @box.is_owned_by(current_user)
      if @box.update(box_params)
        render json: @box
      else
        render json: @box.errors, status: :unprocessable_entity
      end
    else
      forbidden
    end
  end

  # DELETE /boxes/1
  def destroy
    if @box.is_owned_by(current_user)
      @box.removed = true
    else
      forbidden
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_box
    @box = Box.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def box_params
    params[:owner_id] = current_user.id
    params.permit(:name, :notice, :owner_id)
  end
end
