# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Foods::VersionsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit) { create(:unit, user: user) }
    let(:food) { create(:food, box: box, unit: unit, created_user: user, updated_user: user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns the requested food as @food' do
      get :index, params: { food_id: food.to_param }
      expect(assigns(:food)).to eq(food)
    end
  end

  describe 'POST #create' do
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
      food.update(name: name_after)

      request.headers['Authorization'] = "Bearer #{token(user)}"

      post :create, params: { food_id: food.to_param }
      food.reload
    end

    it 'revert the requested food' do
      expect(food.name).to eq(name_before)
    end

    it 'assigns the reverted food as @food' do
      expect(assigns(:food)).to eq(food)
    end
  end
end
