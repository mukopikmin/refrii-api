# frozen_string_literal: true

module V1
  class FoodsController < V1::ApplicationController
    before_action :authenticate_request!
    before_action :set_paper_trail_whodunnit
    before_action :set_food, only: %i[show versions image update revert destroy]

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
        render json: @food, include: %i[box unit created_user updated_user]
      end
    end

    # GET /foods/1/versions
    def versions
      render json: @food.versions
    end

    # POST /foods
    def create
      @food = Food.new(food_params)
      @food.created_user = current_user

      if !accessible?
        bad_request('Could not create food in specified box.')
      elsif @food.save
        render json: @food, status: :created, location: v1_foods_path(@food)
      else
        bad_request
      end
    end

    # GET /foods/1/image
    def image
      if @food.image_exists? && accessible?
        if requested_base64?
          render json: @food.base64_image
        else
          send_data @food.image_file, type: @food.image_content_type, disposition: 'inline'
        end
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

    # PUT /boxes/1/revert
    def revert
      if !accessible?
        bad_request('You can not revert the food.')
      elsif @food.revert
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

      if image_attached?(image)
        original = Magick::Image.from_blob(image.read).first
        params[:image_file] = original.resize_to_fit(Settings.rmagick.width, Settings.rmagick.height).to_blob
        params[:image_size] = params[:image_file].size
        params[:image_content_type] = image.content_type
      end

      params[:updated_user_id] = current_user.id

      params.permit(:name, :notice, :amount, :expiration_date, :needs_adding, :box_id, :unit_id, :updated_user_id, :image_file, :image_size, :image_content_type)
    end

    def accessible?
      @food.box.accessible_for?(current_user)
    end

    def requested_base64?
      params[:base64] == 'true'
    end

    def image_attached?(param)
      !(param == 'null' || param == '' || param.nil?)
    end
  end
end
