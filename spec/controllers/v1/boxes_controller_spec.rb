# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::BoxesController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let!(:box) { create(:box, owner: user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns all boxes as @boxes' do
      get :index
      expect(assigns(:boxes)).to eq([box])
    end
  end

  describe 'GET #owns' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let!(:box1) { create(:box, owner: user1) }

    before { create(:box, owner: user2) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user1)}"
    end

    it 'assigns own boxes as @boxes' do
      get :owns
      expect(assigns(:boxes)).to eq([box1])
    end
  end

  describe 'GET #invited' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:box1) { create(:box, owner: user1) }
    let(:box2) { create(:box, owner: user2) }

    before { Invitation.create(box: box1, user: user2) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user2)}"
    end

    it 'assigns all boxes as @boxes' do
      get :invited
      expect(assigns(:boxes)).to eq([box1])
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns the requested box as @box' do
      get :show, params: { id: box.to_param }
      expect(assigns(:box)).to eq(box)
    end
  end

  describe 'GET #versions' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns the requested box as @box' do
      get :versions, params: { id: box.to_param }
      expect(assigns(:box)).to eq(box)
    end
  end

  describe 'GET #foods' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns the requested food as @food' do
      get :foods, params: { id: box.to_param }
      expect(assigns(:box)).to eq(box)
    end
  end

  describe 'GET #image' do
    let(:user) { create(:user) }
    let(:box) { create(:box, :with_image, owner: user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns the requested food as @food' do
      get :image, params: { id: box.to_param }
      expect(assigns(:box)).to eq(box)
    end
  end

  describe 'GET #units' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let!(:unit) { create(:unit, user: user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    context 'with own boxes' do
      it 'assigns the requested units as @units' do
        get :units, params: { id: box.to_param }
        expect(assigns(:units)).to eq([unit])
      end
    end

    # context 'with invited boxes' do
    # end
  end

  describe 'POST #create' do
    let!(:user) { create(:user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    context 'with valid params' do
      it 'creates a new Box' do
        expect do
          post :create, params: attributes_for(:box)
        end.to change(Box, :count).by(1)
      end

      it 'assigns a newly created box as @box' do
        post :create, params: attributes_for(:box)
        expect(assigns(:box)).to be_a(Box)
        expect(assigns(:box)).to be_persisted
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved box as @box' do
        post :create, params: attributes_for(:no_name_box)
        expect(assigns(:box)).to be_a(Box)
        expect(assigns(:box)).not_to be_persisted
      end
    end
  end

  describe 'PUT #update' do
    let!(:user) { create(:user) }
    let!(:box) { create(:box, owner: user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'updates the requested box' do
      put :update, params: { id: box.to_param }.merge!(attributes_for(:another_box))
      box.reload
      expect(box.name).to eq(attributes_for(:another_box)[:name])
    end

    it 'assigns the requested box as @box' do
      put :update, params: { id: box.to_param }.merge!(attributes_for(:another_box))
      expect(assigns(:box)).to eq(box)
    end
  end

  describe 'PUT #revert' do
    let!(:user) { create(:user) }
    let!(:box) { create(:box, name: name_before, owner: user) }
    let(:name_before) { 'before changed' }
    let(:name_after) { 'after changed' }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
      put :update, params: { id: box.to_param, name: name_after }
    end

    it 'revert the requested box' do
      put :revert, params: { id: box.to_param }
      box.reload
      expect(box.name).to eq(name_before)
    end

    it 'assigns the reverted box as @box' do
      put :revert, params: { id: box.to_param }
      expect(assigns(:box)).to eq(box)
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:box) { create(:box, owner: user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'destroys the requested box' do
      expect do
        delete :destroy, params: { id: box.to_param }
      end.to change(Box, :count).by(-1)
    end
  end
end
