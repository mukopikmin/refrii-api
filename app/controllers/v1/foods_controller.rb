# frozen_string_literal: true

class V1::FoodsController < V1::ApplicationController
  before_action :authenticate_request!
  before_action :set_paper_trail_whodunnit
  before_action :set_food, only: %i[show update destroy]

  # GET /foods
  def index
    render json: Food.all_with_invited(current_user)
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
      render json: @food, status: :created
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

  def set_food
    @food = Food.find(params[:id])
  end

  def food_params
    params[:updated_user_id] = current_user.id

    params.permit(:name,
                  :amount,
                  :expiration_date,
                  :image,
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
    if params[:unit_id].nil?
      true
    else
      @food.assignable_units
           .map(&:id)
           .include?(params[:unit_id].to_i)
    end
  end
end
