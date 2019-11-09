# frozen_string_literal: true

class V1::Boxes::InvitationsController < V1::ApplicationController
  before_action :authenticate_request!
  before_action :set_box

  # POST /boxes/1/invitations
  def create
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

  private

  def set_box
    @box = Box.find(params[:box_id])
  end

  def invitatation_params
    user = User.where(email: params[:email]).first

    params[:user_id] = user.nil? ? nil : user.id

    params.permit(:box_id, :user_id)
  end

  def invited?
    Invitation.exists?(invitatation_params.to_h)
  end

  def owner_of_box?
    @box.owned_by?(current_user)
  end
end
