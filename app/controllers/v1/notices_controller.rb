# frozen_string_literal: true

class V1::NoticesController < V1::ApplicationController
  before_action :authenticate_request!
  before_action :set_notice, only: %i[destroy]

  # DELETE /notices/:id
  def destroy
    if !accessible?
      not_found
    else
      @notice.destroy
    end
  end

  private

  def accessible?
    @notice.food.box.accessible_for?(current_user)
  end

  def set_notice
    @notice = Notice.find(params[:id])
  end
end
