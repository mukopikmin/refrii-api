# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::UnitsController, type: :controller do
  def token(user)
    JsonWebToken.payload(user)[:jwt]
  end

  describe 'GET #index' do
    before do
      request.headers['Authorization'] = "Bearer #{token(unit.user)}"
    end

    let(:unit) { create(:unit, :with_user) }

    it 'assigns all units as @units' do
      get :index
      expect(assigns(:units)).to eq([unit])
    end
  end

  describe 'GET #show' do
    before do
      request.headers['Authorization'] = "Bearer #{token(unit.user)}"
    end

    let(:unit) { create(:unit, :with_user) }

    it 'assigns the requested unit as @unit' do
      get :show, params: { id: unit.to_param }
      expect(assigns(:unit)).to eq(unit)
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    context 'with valid params' do
      it 'creates a new Unit' do
        expect do
          post :create, params: attributes_for(:unit, :with_user)
        end.to change(Unit, :count).by(1)
      end

      it 'assigns a newly created unit as @unit' do
        post :create, params: attributes_for(:unit, :with_user)
        expect(assigns(:unit)).to be_a(Unit)
        expect(assigns(:unit)).to be_persisted
      end
    end

    context 'without label' do
      it 'assigns a newly created but unsaved unit as @unit' do
        post :create, params: attributes_for(:no_label_unit)
        expect(assigns(:unit)).to be_a(Unit)
        expect(assigns(:unit)).not_to be_persisted
      end
    end
  end

  describe 'PUT #update' do
    let(:unit) { create(:unit, :with_user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(unit.user)}"
    end

    it 'assigns the requested unit as @unit' do
      put :update, params: { id: unit.to_param }.merge!(attributes_for(:updated_unit))
      expect(assigns(:unit)).to eq(unit)
    end
  end

  describe 'DELETE #destroy' do
    let(:unit) { create(:unit, :with_user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(unit.user)}"
    end

    context 'with units not refernced by foods' do
      it 'destroys the requested unit' do
        expect do
          delete :destroy, params: { id: unit.to_param }
        end.to change(Unit, :count).by(-1)
      end
    end

    context 'with units refernced by foods' do
      let(:user) { create(:user) }
      let(:box) { create(:box, owner: user) }

      before { create(:food, box: box, unit: unit, created_user: user, updated_user: user) }

      it 'not destroy the requested unit' do
        expect do
          delete :destroy, params: { id: unit.to_param }
        end.to change(Unit, :count).by(0)
      end
    end
  end
end
