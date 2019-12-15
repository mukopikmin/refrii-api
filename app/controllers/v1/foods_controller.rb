# frozen_string_literal: true

class V1::FoodsController < V1::ApplicationController
  before_action :authenticate_request!
  before_action :set_paper_trail_whodunnit
  before_action :set_food, only: %i[show update destroy]

  # GET /foods
  def index
    @foods = Food.all_with_invited(current_user)

    render json: @foods
  end

  # GET /foods/1
  def show
    if !box_accessible?
      not_found
    else
      render json: @food
    end
  end

  # POST /foods
  def create
    @food = Food.new(food_params)
    @food.created_user = current_user

    if !box_accessible?
      bad_request('Could not create food in specified box.')
    elsif !unit_assignable?
      bad_request('The unit is not assignable to the food.')
    elsif @food.save
      @food.image.attach(attachment_param(params[:image])) if image_in_params?

      render json: @food, status: :created, location: v1_foods_path(@food)
    else
      bad_request
    end
  end

  # PATCH/PUT /foods/1
  def update
    if !box_accessible?
      bad_request('Could not update specified food.')
    elsif !unit_assignable?
      bad_request('The unit is not assignable to the food.')
    elsif @food.update(food_params)
      @food.image.attach(attachment_param(params[:image])) if image_in_params?

      render json: @food
    else
      bad_request
    end
  end

  # DELETE /foods/1
  def destroy
    if !box_accessible?
      bad_request('Could not remove specified food.')
    else
      @food.destroy
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_food
    @food = Food.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def food_params
    params[:updated_user_id] = current_user.id

    params.permit(:name,
                  :amount,
                  :expiration_date,
                  :box_id,
                  :unit_id,
                  :updated_user_id)
  end

  def image_in_params?
    !params[:image].nil?
  end

  def box_accessible?
    @food.box.accessible_for?(current_user)
  end

  def unit_assignable?
    unit_id = params[:unit_id].nil? ? nil : params[:unit_id].to_i

    if unit_id.nil?
      true
    else
      @food.assignable_units.map(&:id).include?(unit_id)
    end
  end
end
