require 'rails_helper'

RSpec.describe BoxesController, type: :controller do
  def token(user)
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  describe 'GET #index' do
    let!(:user) { create(:user) }
    let!(:box) { create(:box, owner: user) }

    before(:each) do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns all boxes as @boxes' do
      get :index
      expect(assigns(:boxes)).to eq([box])
    end
  end

  describe 'GET #show' do
    let!(:user) { create(:user) }
    let!(:box) { create(:box, owner: user) }

    before(:each) do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns the requested box as @box' do
      get :show, params: { id: box.to_param }
      expect(assigns(:box)).to eq(box)
    end
  end

  describe 'POST #create' do
    let!(:user) { create(:user) }

    before(:each) do
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
        expect do
          post :create, params: attributes_for(:no_name_box)
        end.to raise_error(ActiveRecord::StatementInvalid)
      end
    end
  end

  describe 'PUT #update' do
    let!(:user) { create(:user) }
    let!(:box) { create(:box, owner: user) }

    before(:each) do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    context 'with valid params' do
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

    xcontext 'with invalid params' do
      it 'assigns the box as @box' do
        put :update, params: { id: box.to_param }.merge!(attributes_for(:another_box))
        expect(assigns(:box)).to eq(box)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:box) { create(:box, owner: user) }

    before(:each) do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'destroys the requested box' do
      expect do
        delete :destroy, params: { id: box.to_param }
      end.to change(Box, :count).by(-1)
    end
  end
end
