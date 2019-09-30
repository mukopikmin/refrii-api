# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::ShopPlansController, type: :controller do
  let(:user) { create(:user) }
  let(:box) { create(:box, owner: user) }
  let(:unit) { create(:unit, user: user) }
  let!(:food) do
    create(:food, box: box,
                  unit: unit,
                  created_user: box.owner,
                  updated_user: box.owner)
  end
  let!(:shop_plan) { create(:shop_plan, food: food) }

  describe 'GET #index' do
    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
      get :index
    end

    # it 'returns a success response' do
    #   expect(response).to be_successful
    # end

    it 'assigns all shop_plans as @shop_plans' do
      expect(assigns(:shop_plans)).to eq([shop_plan])
    end
  end

  describe 'GET #show' do
    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
      get :show, params: { id: shop_plan.to_param }
    end

    # it 'returns a success response' do
    #   expect(response).to be_successful
    # end

    it 'assigns the requested shop_plan as @shop_plan' do
      get :show, params: { id: shop_plan.to_param }
      expect(assigns(:shop_plan)).to eq(shop_plan)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      before do
        request.headers['Authorization'] = "Bearer #{token(user)}"
      end

      let(:params) { attributes_for(:shop_plan).merge!(food_id: food.id) }

      it 'creates a new ShopPlan' do
        expect do
          post :create, params: params
        end.to change(ShopPlan, :count).by(1)
      end

      # it 'renders a JSON response with the new shop_plan' do
      #   post :create, params: params
      #   expect(response).to have_http_status(:created)
      #   expect(response.content_type).to eq('application/json')
      #   # expect(response.location).to eq(shop_plan_url(ShopPlan.last))
      # end
      it 'assigns a newly created shop_plsn as @shop_plsn' do
        post :create, params: params
        expect(assigns(:shop_plan)).to be_a(ShopPlan)
        expect(assigns(:shop_plan)).to be_persisted
      end
    end

    context 'with invalid params' do
      before do
        request.headers['Authorization'] = "Bearer #{token(user)}"
        post :create, params: params
      end

      let(:params) { attributes_for(:no_amount_shop_plan).merge!(food_id: food.id) }

      # it 'renders a JSON response with errors for the new shop_plan' do
      #   expect(response).to have_http_status(:unprocessable_entity)
      #   expect(response.content_type).to eq('application/json')
      # end

      it 'assigns a newly created but unsaved shop_plan as @shop_plan' do
        # post :create, params: params
        expect(assigns(:shop_plan)).to be_a(ShopPlan)
        expect(assigns(:shop_plan)).not_to be_persisted
      end
    end
  end

  describe 'PUT #update' do
    # context 'with valid params' do
      before do
        request.headers['Authorization'] = "Bearer #{token(user)}"
        put :update, params: params
        shop_plan.reload
      end

      let(:params) { attributes_for(:shop_plan).merge!(id: shop_plan.to_param, food_id: food.id) }

      it 'updates the requested shop_plan' do
        expect(shop_plan.notice).to eq(params[:notice])
      end

      # it 'renders a JSON response with the shop_plan' do
      #   expect(response).to have_http_status(:ok)
      #   expect(response.content_type).to eq('application/json')
      # end

      it 'assigns the requested shop_plan as @shop_plan' do
        put :update, params: params
        expect(assigns(:shop_plan)).to eq(shop_plan)
      end
    # end

    # context 'with invalid params' do
    #   before do
    #     request.headers['Authorization'] = "Bearer #{token(user)}"
    #     put :update, params: params
    #     shop_plan.reload
    #   end

    #   let(:params) { attributes_for(:shop_plan) }

    #   it 'renders a JSON response with errors for the shop_plan' do
    #     expect(response).to have_http_status(:unprocessable_entity)
    #     expect(response.content_type).to eq('application/json')
    #   end
    # end
  end

  describe 'DELETE #destroy' do
    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'destroys the requested shop_plan' do
      expect do
        delete :destroy, params: { id: shop_plan.to_param }
      end.to change(ShopPlan, :count).by(-1)
    end
  end
end
