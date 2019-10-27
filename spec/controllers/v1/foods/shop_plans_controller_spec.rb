# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Foods::ShopPlansController, type: :controller do
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
end
