class FoodsController < ApplicationController
  before_action :set_food, only: [:show, :update, :destroy]
  before_action :authenticate_user

  # GET /foods
  def index
    @foods = Food.all
    render json: @foods
  end

  # GET /foods/1
  def show
    if @food.box.is_owned_by(current_user)
      render json: @food
    else
      forbidden
    end
  end

  # POST /foods
  def create
    @food = Food.new(food_params)

    if @food.save
      render json: @food, status: :created, location: @food
    else
      render json: @food.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /foods/1
  def update
    if @food.box.is_owned_by(current_user)
      if @food.update(food_params)
        render json: @food
      else
        render json: @food.errors, status: :unprocessable_entity
      end
    else
      forbidden
    end
  end

  # DELETE /foods/1
  def destroy
    if @food.box.is_owned_by(current_user)
      @food.destroy
    else
      forbidden
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_food
    @food = Food.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def food_params
    params.permit(:name, :notice, :amount, :expiration_date, :box_id, :unit_id)
  end
end
