# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Boxes::FoodsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns the requested food as @food' do
      get :index, params: { box_id: box.to_param }
      expect(assigns(:box)).to eq(box)
    end
  end
end
