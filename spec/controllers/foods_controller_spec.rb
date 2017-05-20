require 'rails_helper'

RSpec.describe FoodsController, type: :controller do
  def token(user)
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:box) { create(:box, user: user) }
    let(:unit) { create(:unit, user: user) }
    let!(:food) { create(:food, box: box, unit: unit) }

    before(:each) do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns all foods as @foods' do
      get :index
      expect(assigns(:foods)).to eq([food])
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:box) { create(:box, user: user) }
    let(:unit) { create(:unit, user: user) }
    let(:food) { create(:food, box: box, unit: unit) }

    before(:each) do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns the requested food as @food' do
      get :show, params: { id: food.to_param }
      expect(assigns(:food)).to eq(food)
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:box) { create(:box, user: user) }
    let(:unit) { create(:unit, user: user) }

    before(:each) do
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
    let(:box) { create(:box, user: user) }
    let(:unit) { create(:unit, user: user) }
    let(:food) { create(:food, box: box, unit: unit) }

    before(:each) do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    context 'with valid params' do
      let(:new_attributes) do
        attributes_for(:another_food)
      end

      it 'assigns the requested food as @food' do
        put :update, params: { id: food.to_param }.merge!(new_attributes)
        expect(assigns(:food)).to eq(food)
      end
    end

    xcontext 'with invalid params' do
      it 'assigns the food as @food' do
        food = Food.create! valid_attributes
        put :update, params: { id: food.to_param, food: invalid_attributes }, session: valid_session
        expect(assigns(:food)).to eq(food)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:box) { create(:box, user: user) }
    let(:unit) { create(:unit, user: user) }
    let!(:food) { create(:food, box: box, unit: unit) }

    before(:each) do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'destroys the requested food' do
      expect do
        delete :destroy, params: { id: food.to_param }
      end.to change(Food, :count).by(-1)
    end
  end
end
