# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::ShopPlansController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # ShopPlan. As you add validations to ShopPlan, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    skip('Add a hash of attributes valid for your model')
  end

  let(:invalid_attributes) do
    skip('Add a hash of attributes invalid for your model')
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ShopPlansController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      ShopPlan.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      shop_plan = ShopPlan.create! valid_attributes
      get :show, params: { id: shop_plan.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new ShopPlan' do
        expect do
          post :create, params: { shop_plan: valid_attributes }, session: valid_session
        end.to change(ShopPlan, :count).by(1)
      end

      it 'renders a JSON response with the new shop_plan' do
        post :create, params: { shop_plan: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(shop_plan_url(ShopPlan.last))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new shop_plan' do
        post :create, params: { shop_plan: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested shop_plan' do
        shop_plan = ShopPlan.create! valid_attributes
        put :update, params: { id: shop_plan.to_param, shop_plan: new_attributes }, session: valid_session
        shop_plan.reload
        skip('Add assertions for updated state')
      end

      it 'renders a JSON response with the shop_plan' do
        shop_plan = ShopPlan.create! valid_attributes

        put :update, params: { id: shop_plan.to_param, shop_plan: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the shop_plan' do
        shop_plan = ShopPlan.create! valid_attributes

        put :update, params: { id: shop_plan.to_param, shop_plan: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested shop_plan' do
      shop_plan = ShopPlan.create! valid_attributes
      expect do
        delete :destroy, params: { id: shop_plan.to_param }, session: valid_session
      end.to change(ShopPlan, :count).by(-1)
    end
  end
end
