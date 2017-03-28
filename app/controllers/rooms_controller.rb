class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :update, :destroy]

  # GET /rooms
  def index
    @rooms = Room.joins(:box).where(removed: false, boxes: { owner: current_user})

    render json: @rooms
  end

  # GET /rooms/1
  def show
    if @room.box.is_owned_by(current_user)
      render json: @room
    else
      forbidden
    end
  end

  # POST /rooms
  def create
    @room = Room.new(room_params)
    if @room.box.is_owned_by(current_user)
      if @room.save
        render json: @room, status: :created, location: @room
      else
        render json: @room.errors, status: :unprocessable_entity
      end
    else
      forbidden
    end
  end

  # PATCH/PUT /rooms/1
  def update
    if @room.box.is_owned_by(current_user)
      if @room.update(room_params)
        render json: @room
      else
        render json: @room.errors, status: :unprocessable_entity
      end
    else
      forbidden
    end
  end

  # DELETE /rooms/1
  def destroy
    if @room.box.is_owned_by(current_user)
      @room.removed = true
    else
      forbidden
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def room_params
      params.permit(:name, :notice, :box_id)
    end
end
