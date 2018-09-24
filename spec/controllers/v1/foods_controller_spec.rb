# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::FoodsController, type: :controller do
  def token(user)
    JsonWebToken.payload(user)[:jwt]
  end

  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit) { create(:unit, user: user) }
    let!(:food) do
      create(:food, box: box,
                    unit: unit,
                    created_user: box.owner,
                    updated_user: box.owner)
    end

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns all foods as @foods' do
      get :index
      expect(assigns(:foods)).to eq([food])
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit) { create(:unit, user: user) }
    let(:food) do
      create(:food, box: box,
                    unit: unit,
                    created_user: box.owner,
                    updated_user: box.owner)
    end

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns the requested food as @food' do
      get :show, params: { id: food.to_param }
      expect(assigns(:food)).to eq(food)
    end
  end

  describe 'GET #image' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit) { create(:unit, user: user) }
    let(:food) { create(:food, :with_image, box: box, unit: unit, created_user: user, updated_user: user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns the requested food as @food' do
      get :image, params: { id: food.to_param }
      expect(assigns(:food)).to eq(food)
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit) { create(:unit, user: user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    context 'with valid params' do
      it 'creates a new Food' do
        expect do
          post :create, params: attributes_for(:food).merge!(box_id: box.id, unit_id: unit.id)
        end.to change(Food, :count).by(1)
      end

      it 'assigns a newly created food as @food' do
        post :create, params: attributes_for(:food).merge!(box_id: box.id, unit_id: unit.id)
        expect(assigns(:food)).to be_a(Food)
        expect(assigns(:food)).to be_persisted
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved food as @food' do
        post :create, params: attributes_for(:no_name_food).merge!(box_id: box.id, unit_id: unit.id)
        expect(assigns(:food)).to be_a(Food)
        expect(assigns(:food)).not_to be_persisted
      end
    end
  end

  describe 'PUT #update' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit) { create(:unit, user: user) }
    let(:food) do
      create(:food, box: box,
                    unit: unit,
                    created_user: box.owner,
                    updated_user: box.owner)
    end

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'updates the requested food' do
      put :update, params: { id: food.to_param }.merge!(attributes_for(:another_food))
      food.reload
      expect(food.name).to eq(attributes_for(:another_food)[:name])
    end

    it 'assigns the requested food as @food' do
      put :update, params: { id: food.to_param }.merge!(attributes_for(:another_food))
      expect(assigns(:food)).to eq(food)
    end
  end

  describe 'PUT #revert' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit) { create(:unit, user: user) }
    let(:food) do
      create(:food, name: name_before,
                    box: box,
                    unit: unit,
                    created_user: box.owner,
                    updated_user: box.owner)
    end
    let(:name_before) { 'before changed' }
    let(:name_after) { 'after changed' }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
      put :update, params: { id: food.to_param, name: name_after }
    end

    it 'revert the requested food' do
      put :revert, params: { id: food.to_param }
      food.reload
      expect(food.name).to eq(name_before)
    end

    it 'assigns the reverted food as @food' do
      put :revert, params: { id: food.to_param }
      expect(assigns(:food)).to eq(food)
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit) { create(:unit, user: user) }
    let!(:food) do
      create(:food, box: box,
                    unit: unit,
                    created_user: box.owner,
                    updated_user: box.owner)
    end

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'destroys the requested food' do
      expect do
        delete :destroy, params: { id: food.to_param }
      end.to change(Food, :count).by(-1)
    end
  end
end
