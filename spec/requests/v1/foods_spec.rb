# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Foods', type: :request do
  include Committee::Rails::Test::Methods

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:box1) { create(:box, owner: user1) }
  let(:box2) { create(:box, owner: user2) }
  let(:unit1) { create(:unit, user: user1) }
  let(:unit2) { create(:unit, user: user2) }
  let(:food1) do
    create(:food, box: box1,
                  unit: unit1,
                  created_user: box1.owner,
                  updated_user: box1.owner)
  end
  let(:food2) do
    create(:food, box: box2,
                  unit: unit2,
                  created_user: box2.owner,
                  updated_user: box2.owner)
  end
  let(:notice) { create(:notice, food: food1, created_user: user1) }

  describe 'GET /foods' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_foods_path }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      subject { response.status }

      before { get v1_foods_path, headers: { authorization: "Bearer #{token(user1)}" } }

      it { is_expected.to eq(200) }
      it { assert_schema_conform }
    end
  end

  describe 'GET /foods/:id' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_food_path(food1) }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      context 'with food in own box' do
        subject { response.status }

        before { get v1_food_path(food1), headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(200) }
        it { assert_schema_conform }
      end

      context 'with food in other\'s box' do
        subject { response.status }

        before { get v1_food_path(food2), headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(404) }
        it { assert_schema_conform }
      end
    end
  end

  describe 'POST /foods' do
    context 'without authentication' do
      subject { response.status }

      let(:params) { attributes_for(:food).merge!(box_id: box1.to_param, unit_id: unit1.to_param) }

      before { post v1_foods_path, params: params }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      context 'with food in own box' do
        subject { response.status }

        let(:params) { attributes_for(:food).merge!(box_id: box1.to_param, unit_id: unit1.to_param) }

        before { post v1_foods_path, params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(201) }
        it { assert_schema_conform }
      end

      context 'with food in other\'s box' do
        subject { response.status }

        let(:params) { attributes_for(:food).merge!(box_id: box2.to_param, unit_id: unit2.to_param) }

        before { post v1_foods_path, params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(400) }
        it { assert_schema_conform }
      end

      context 'with no name food' do
        subject { response.status }

        let(:params) { attributes_for(:no_name_food).merge!(box_id: box1.to_param, unit_id: unit1.to_param) }

        before { post v1_foods_path, params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(400) }
        it { assert_schema_conform }
      end

      context 'with unit for box owned by other users' do
        subject { response.status }

        let(:params) { { box_id: box1.to_param, unit_id: unit2.to_param } }

        before { post v1_foods_path, params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(400) }
        it { assert_schema_conform }
      end
    end
  end

  describe 'PUT /foods/:id' do
    let(:params) { attributes_for(:food) }

    context 'without authentication' do
      subject { response.status }

      before { put v1_food_path(food1), params: params }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      context 'with food in own box' do
        subject { response.status }

        before { put v1_food_path(food1), params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(200) }
        it { assert_schema_conform }
      end

      context 'with food in other\'s box' do
        subject { response.status }

        before { put v1_food_path(food2), params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(400) }
        it { assert_schema_conform }
      end

      context 'with no name food' do
        subject { response.status }

        let(:no_name_params) { attributes_for(:no_name_food) }

        before { put v1_food_path(food1), params: no_name_params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(400) }
        it { assert_schema_conform }
      end

      context 'with unit for box owned by other users' do
        subject { response.status }

        let(:params) { { unit_id: unit2.to_param } }

        before { put v1_food_path(food1), params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(400) }
        it { assert_schema_conform }
      end
    end
  end

  describe 'DELETE /foods/:id' do
    context 'without authentication' do
      subject { response.status }

      before { delete v1_food_path(food1) }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      context 'with food in own box' do
        subject { response.status }

        before { delete v1_food_path(food1), headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(204) }
        it { assert_schema_conform }
      end

      context 'with food in other\'s box' do
        subject { response.status }

        before { delete v1_food_path(food2), headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(400) }
        it { assert_schema_conform }
      end
    end
  end
end
