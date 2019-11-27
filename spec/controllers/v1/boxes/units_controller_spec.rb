# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Boxes::UnitsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let!(:unit) { create(:unit, user: user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    context 'with own boxes' do
      it 'assigns the requested units as @units' do
        get :index, params: { box_id: box.to_param }
        expect(assigns(:units)).to eq([unit])
      end
    end
  end
end
