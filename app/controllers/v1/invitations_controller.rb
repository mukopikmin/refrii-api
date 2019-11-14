# frozen_string_literal: true

class V1::InvitationsController < V1::ApplicationController
  before_action :authenticate_request!
  before_action :set_invitation

  # DELETE /invitations/1
  def destroy
    if !owner_of_box?
      bad_request('You can not delete the invitation.')
    elsif @invitation.nil?
      bad_request('Specified invitation does not exist.')
    else
      @invitation.destroy
    end
  end

  private

  def set_invitation
    @invitation = Invitation.find(params[:id])
  end

  def owner_of_box?
    @invitation.box.owned_by?(current_user)
  end
end
