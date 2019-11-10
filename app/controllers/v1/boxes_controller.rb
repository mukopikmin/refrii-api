# frozen_string_literal: true

class V1::BoxesController < V1::ApplicationController
  before_action :authenticate_request!
  before_action :set_paper_trail_whodunnit
  before_action :set_box, only: %i[show versions foods image units update revert destroy invite uninvite]
  before_action :set_invitation, only: [:uninvite]

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
      render json: @box
    end
  end

  # GET /boxes/1/versions
  # def versions
  #   render json: @box.versions
  # end

  # GET /boxes/1/foods
  def foods
    if !accessible?
      not_found('Specified box does not exist.')
    else
      render json: @box.foods
    end
  end

  # GET /boxes/1/units
  def units
    @units = @box.owner.units

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
      render json: @box, status: :created, location: v1_boxes_path(@box)
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
      p box_params
      bad_request
    end
  end

  # PUT /boxes/1/revert
  # def revert
  #   if !owner_of_box?
  #     bad_request('You can not revert the box.')
  #   elsif @box.revert
  #     render json: @box
  #   else
  #     bad_request
  #   end
  # end

  # DELETE /boxes/1
  def destroy
    if !owner_of_box?
      bad_request('You can not destroy the box.')
    else
      @box.destroy
    end
  end

  # # POST /boxes/1/invite
  # def invite
  #   @invitation = Invitation.new(invitatation_params)

  #   if invited?
  #     bad_request('The invitation already exists.')
  #   elsif !owner_of_box?
  #     bad_request('You can not invite to the box.')
  #   elsif @invitation.save
  #     render json: @invitation, status: :created
  #   else
  #     bad_request
  #   end
  # end

  # # DELETE /boxes/1/invite
  # def uninvite
  #   if !owner_of_box?
  #     bad_request('You can not delete the invitation.')
  #   elsif @invitation.nil?
  #     bad_request('Specified invitation does not exist.')
  #   else
  #     @invitation.destroy
  #   end
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_box
    @box = Box.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def box_params
    params[:owner_id] = current_user.id

    params.permit(:name,
                  :notice,
                  :owner_id,
                  :image_file,
                  :image_size,
                  :image,
                  :image_content_type)
  end

  def set_invitation
    user = User.where(email: params[:email]).first

    @invitation = Invitation.find_by(user: user, box: @box)
  end

  def accessible?
    @box.accessible_for?(current_user)
  end

  def owner_of_box?
    @box.owned_by?(current_user)
  end
end
