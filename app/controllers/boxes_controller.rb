class BoxesController < ApplicationController
  before_action :authenticate_request!
  before_action :set_box, only: [:show, :units, :update, :destroy, :invite, :deinvite]
  before_action :set_invitation, only: [:deinvite]

  # GET /boxes
  def index
    @boxes = Box.all_with_invited(current_user)
    render json: @boxes
  end

  # GET /boxes/owns
  def owns
    @boxes = Box.owned_by(current_user)
    render json: @boxes
  end

  # GET /boxes/invited
  def invited
    @boxes = Box.inviting(current_user)
    render json: @boxes
  end

  # GET /boxes/1
  def show
    if !accessible?
      not_found('Specified box does not exist.')
    else
      render json: @box, include: [:user, { foods: :unit }]
    end
  end

  # GET /boxes/1/units
  def units
    @units = @box.user.units

    if !accessible?
      not_found('Specified box does not exist.')
    else
      render json: @units
    end
  end

  # POST /boxes
  def create
    @box = Box.new(box_params)

    if @box.save
      render json: @box, status: :created, location: @box
    else
      bad_request
    end
  end

  # PATCH/PUT /boxes/1
  def update
    if !owner_of_box?
      bad_request('You can not update the box.')
    elsif @box.update(box_params)
      render json: @box
    else
      bad_request
    end
  end

  # DELETE /boxes/1
  def destroy
    if !owner_of_box?
      bad_request('You can not destroy the box.')
    else
      @box.destroy
    end
  end

  # POST /boxes/1/invite
  def invite
    @invitation = Invitation.new(invitatation_params)

    if invited?
      bad_request('The invitation already exists.')
    elsif !owner_of_box?
      bad_request('You can not invite to the box.')
    elsif @invitation.save
      render json: @invitation, status: :created
    else
      bad_request
    end
  end

  # DELETE /boxes/1/invite
  def deinvite
    if @invitation.nil?
      bad_request('Specified invitation does not exist.')
    else
      @invitation.destroy
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_box
    @box = Box.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def box_params
    params[:user_id] = current_user.id
    params.permit(:name, :notice, :user_id)
  end

  def set_invitation
    @invitation = Invitation.find_by(user: current_user, box: @box)
  end

  def invitatation_params
    params[:box_id] = params[:id]
    params.permit(:box_id, :user_id)
  end

  def accessible?
    @box.is_accessible_for(current_user)
  end

  def owner_of_box?
    @box.is_owned_by(current_user)
  end

  def invited?
    Invitation.exists?(invitatation_params.to_h)
  end
end
