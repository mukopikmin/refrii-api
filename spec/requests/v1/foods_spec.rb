# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Foods', type: :request do
  include Committee::Rails::Test::Methods

  let(:food1) { create(:food, :with_box_user_unit) }
  let(:food2) { create(:food, :with_box_user_unit) }

  before { create(:notice, food: food1, created_user: food1.box.owner, updated_user: food1.box.owner) }

  describe 'GET /foods' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_foods_path }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      subject { response.status }

      before { get v1_foods_path, headers: { authorization: "Bearer #{token(food1.box.owner)}" } }

      it { is_expected.to eq(200) }
      it { assert_response_schema_confirm }
    end
  end

  describe 'GET /foods/:id' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_food_path(food1) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with food in own box' do
        subject { response.status }

        before { get v1_food_path(food1), headers: { authorization: "Bearer #{token(food1.box.owner)}" } }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end

      context 'with food in other\'s box' do
        subject { response.status }

        before { get v1_food_path(food2), headers: { authorization: "Bearer #{token(food1.box.owner)}" } }

        it { is_expected.to eq(404) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'POST /foods' do
    context 'without authentication' do
      subject { response.status }

      let(:params) { attributes_for(:food).merge!(box_id: food1.box.to_param, unit_id: food1.unit.to_param) }

      before { post v1_foods_path, params: params }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with food in own box' do
        subject { response.status }

        let(:params) { attributes_for(:food).merge!(box_id: food1.box.to_param, unit_id: food1.unit.to_param) }

        before { post v1_foods_path, params: params, headers: { authorization: "Bearer #{token(food1.box.owner)}" } }

        it { is_expected.to eq(201) }
        it { assert_response_schema_confirm }
      end

      context 'with food in other\'s box' do
        subject { response.status }

        let(:params) { attributes_for(:food).merge!(box_id: food2.box.to_param, unit_id: food2.unit.to_param) }

        before { post v1_foods_path, params: params, headers: { authorization: "Bearer #{token(food1.box.owner)}" } }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end

      context 'with no name food' do
        subject { response.status }

        let(:params) { attributes_for(:no_name_food).merge!(box_id: food1.box.to_param, unit_id: food1.unit.to_param) }

        before { post v1_foods_path, params: params, headers: { authorization: "Bearer #{token(food1.box.owner)}" } }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end

      context 'with unit for box owned by other users' do
        subject { response.status }

        let(:params) { { box_id: food1.box.to_param, unit_id: food2.unit.to_param } }

        before { post v1_foods_path, params: params, headers: { authorization: "Bearer #{token(food1.box.owner)}" } }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'PUT /foods/:id' do
    let(:params) { attributes_for(:food) }

    context 'without authentication' do
      subject { response.status }

      before { put v1_food_path(food1), params: params }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with food in own box' do
        subject { response.status }

        before { put v1_food_path(food1), params: params, headers: { authorization: "Bearer #{token(food1.box.owner)}" } }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end

      context 'with food in other\'s box' do
        subject { response.status }

        before do
          put v1_food_path(food2), params: params, headers: { authorization: "Bearer #{token(food1.box.owner)}" }
        end

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end

      context 'with no name food' do
        subject { response.status }

        let(:no_name_params) { attributes_for(:no_name_food) }

        before { put v1_food_path(food1), params: no_name_params, headers: { authorization: "Bearer #{token(food1.box.owner)}" } }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end

      context 'with unit for box owned by other users' do
        subject { response.status }

        let(:params) { { unit_id: food2.unit.to_param } }

        before { put v1_food_path(food1), params: params, headers: { authorization: "Bearer #{token(food1.box.owner)}" } }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'DELETE /foods/:id' do
    context 'without authentication' do
      subject { response.status }

      before { delete v1_food_path(food1) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with food in own box' do
        subject { response.status }

        before { delete v1_food_path(food1), headers: { authorization: "Bearer #{token(food1.box.owner)}" } }

        it { is_expected.to eq(204) }
        it { assert_response_schema_confirm }
      end

      context 'with food in other\'s box' do
        subject { response.status }

        before { delete v1_food_path(food2), headers: { authorization: "Bearer #{token(food1.box.owner)}" } }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
