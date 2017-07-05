class FoodsController < ApplicationController
  before_action :set_food, only: [:show, :image, :update, :destroy]
  before_action :authenticate_request!

  # GET /foods
  def index
    @foods = Food.all_with_invited(current_user)
    render json: @foods
  end

  # GET /foods/1
  def show
    if !accessible?
      not_found
    else
      render json: @food
    end
  end

  # POST /foods
  def create
    @food = Food.new(food_params)
    @food.created_user = current_user

    if !accessible?
      bad_request('Could not create food in specified box.')
    elsif @food.save
      render json: @food, status: :created, location: @food
    else
      bad_request
    end
  end

  # GET /foods/1/image
  def image
    if @food.has_image?
      send_data @food.image_file, type: @food.image_content_type, disposition: 'inline'
    else
      not_found('Image does not exist.')
    end
  end

  # PATCH/PUT /foods/1
  def update
    if !accessible?
      bad_request('Could not update specified food.')
    elsif @food.update(food_params)
      render json: @food
    else
      bad_request
    end
  end

  # DELETE /foods/1
  def destroy
    if !accessible?
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
    image = params[:image]
    unless image.nil?
      params[:image_file] = image.read
      params[:image_size] = params[:image_file].size
      params[:image_content_type] = image.content_type
    end
    params[:updated_user_id] = current_user.id
    params.permit(:name, :notice, :amount, :expiration_date, :box_id, :unit_id, :updated_user_id, :image_file, :image_size, :image_content_type)
  end

  def accessible?
    @food.box.is_accessible_for(current_user)
  end
end
