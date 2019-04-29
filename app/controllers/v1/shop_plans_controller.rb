# frozen_string_literal: true

module V1
  class ShopPlansController < V1::ApplicationController
    before_action :authenticate_request!
    before_action :set_shop_plan, only: %i[show update destroy]
    before_action :set_food, only: %i[create]

    # GET /shop_plans
    def index
      @shop_plans = ShopPlan.all_with_invited(User.all.first)

      render json: @shop_plans
    end

    # GET /shop_plans/1
    def show
      if accessible?
        render json: @shop_plan
      else
        not_found
      end
    end

    # POST /shop_plans
    def create
      @shop_plan = ShopPlan.new(shop_plan_params)

      if !accessible_food?
        bad_request
      elsif @shop_plan.save
        render json: @shop_plan, status: :created
      else
        bad_request
      end
    end

    # PATCH/PUT /shop_plans/1
    def update
      if !accessible?
        not_found
      elsif !@shop_plan.update(shop_plan_params)
        bad_request
      else
        render json: @shop_plan
      end
    end

    # DELETE /shop_plans/1
    def destroy
      if accessible?
        @shop_plan.destroy
      else
        not_found
      end
    end

    private

    def set_shop_plan
      @shop_plan = ShopPlan.find(params[:id])
    end

    def set_food
      @food = Food.find(params[:food_id])
    end

    def shop_plan_params
      params.permit(:notice, :done, :date, :amount, :food_id)
    end

    def accessible?
      @shop_plan.accessible_for?(current_user)
    end

    def accessible_food?
      @food.accessible_for?(current_user)
    end
  end
end
