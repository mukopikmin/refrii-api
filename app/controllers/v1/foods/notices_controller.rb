# frozen_string_literal: true

class V1::Foods::NoticesController < V1::ApplicationController
  before_action :authenticate_request!
  before_action :set_food

  # POST /foods/1/notices
  def create
    @notice = Notice.new(notice_params)
    @notice.created_user = current_user
    @notice.updated_user = current_user

    if @food.nil? || !accessible?
      not_found('Food does not exist')
    elsif @notice.save
      render json: @food, status: :created
    else
      bad_request
    end
  end

  private

  def set_food
    @food = Food.find(params[:food_id])
  end

  def notice_params
    params.permit(:text, :food_id, :created_user_id)
  end

  def accessible?
    @food.box.accessible_for?(current_user)
  end
end
