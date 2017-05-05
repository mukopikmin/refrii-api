require 'rails_helper'

RSpec.describe FoodsController, type: :controller do

  def token(user)
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  describe 'GET #index' do
    before(:each) do
      user = create(:user)
      box = create(:box, user: user)
      unit = create(:unit, user: user)
      @food = create(:food, box: box, unit: unit)
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns all foods as @foods' do
      get :index
      expect(assigns(:foods)).to eq([@food])
    end
  end

  describe 'GET #show' do
    before(:each) do
      user = create(:user)
      box = create(:box, user: user)
      unit = create(:unit, user: user)
      @food = create(:food, box: box, unit: unit)
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns the requested food as @food' do
      get :show, params: { id: @food.to_param }
      expect(assigns(:food)).to eq(@food)
    end
  end

  describe 'POST #create' do
    before(:each) do
      user = create(:user)
      @box = create(:box, user: user)
      @unit = create(:unit, user: user)
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    context 'with valid params' do
      it 'creates a new Food' do
        expect {
          post :create, params: attributes_for(:food).merge!({box_id: @box.id, unit_id: @unit.id})
        }.to change(Food, :count).by(1)
      end

      it 'assigns a newly created food as @food' do
        post :create, params: attributes_for(:food).merge!({box_id: @box.id, unit_id: @unit.id})
        expect(assigns(:food)).to be_a(Food)
        expect(assigns(:food)).to be_persisted
      end
    end

    context 'with invalid params' do
      it 'raises error' do
        expect {
          post :create, params: attributes_for(:no_name_food).merge!({box_id: @box.id, unit_id: @unit.id})
        }.to raise_error(ActiveRecord::StatementInvalid)
      end
    end
  end

  describe 'PUT #update' do
    before(:each) do
      user = create(:user)
      box = create(:box, user: user)
      unit = create(:unit, user: user)
      @food = create(:food, box: box, unit: unit)
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    context 'with valid params' do
      let(:new_attributes) do
        attributes_for(:another_food)
      end

      it 'assigns the requested food as @food' do
        put :update, params: { id: @food.to_param}.merge!(new_attributes)
        expect(assigns(:food)).to eq(@food)
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
    before(:each) do
      user = create(:user)
      box = create(:box, user: user)
      unit = create(:unit, user: user)
      @food = create(:food, box: box, unit: unit)
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'destroys the requested food' do
      expect {
        delete :destroy, params: { id: @food.to_param }
      }.to change(Food, :count).by(-1)
    end
  end
end
