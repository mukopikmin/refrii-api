# frozen_string_literal: true

class V1::Boxes::VersionsController < V1::ApplicationController
  before_action :authenticate_request!
  before_action :set_box

  # GET /boxes/1/versions
  def index
    if !accessible?
      not_found
    else
      render json: @box.versions
    end
  end

  # POST /boxes/1/versions
  # Create new versions from previous version as current version
  def create
    if !owner_of_box?
      forbidden('You can not revert the box.')
    elsif @box.revert
      render json: @box, status: :created
    else
      bad_request
    end
  end

  private

  def set_box
    @box = Box.find(params[:box_id])
  end

  def accessible?
    @box.accessible_for?(current_user)
  end

  def owner_of_box?
    @box.owned_by?(current_user)
  end
end
