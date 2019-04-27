# frozen_string_literal: true

module V1
  class ShopPlansController < V1::ApplicationController
    before_action :authenticate_request!
    before_action :set_shop_plan, only: %i[show update destroy]

    # GET /shop_plans
    def index
      @shop_plans = ShopPlan.all

      render json: @shop_plans
    end

    # GET /shop_plans/1
    def show
      render json: @shop_plan
    end

    # POST /shop_plans
    def create
      @shop_plan = ShopPlan.new(shop_plan_params)

      if @shop_plan.save
        render json: @shop_plan, status: :created
      else
        render json: @shop_plan.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /shop_plans/1
    def update
      if @shop_plan.update(shop_plan_params)
        render json: @shop_plan
      else
        render json: @shop_plan.errors, status: :unprocessable_entity
      end
    end

    # DELETE /shop_plans/1
    def destroy
      @shop_plan.destroy
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_shop_plan
      @shop_plan = ShopPlan.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def shop_plan_params
      params.permit(:notice, :done, :date, :food_id)
    end
  end
end
