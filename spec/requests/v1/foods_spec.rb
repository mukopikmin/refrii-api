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

  describe 'GET /foods/:id/versions' do
    context 'without authentication' do
      subject { response.status }

      before { get versions_v1_food_path(food1) }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      context 'with own foods' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user1)}" } }

        before { get versions_v1_food_path(food1), headers: headers }

        it { is_expected.to eq(200) }
        it { assert_schema_conform }
      end

      context 'with other\'s food' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user1)}" } }

        before { get versions_v1_food_path(food2), headers: headers }

        it { is_expected.to eq(404) }
        it { assert_schema_conform }
      end

      context 'with food in invited box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user1)}" } }

        before do
          Invitation.create(box: box2, user: user1)
          get versions_v1_food_path(food2), headers: headers
        end

        it { is_expected.to eq(200) }
        it { assert_schema_conform }
      end
    end
  end

  describe 'GET /foods/:id/shop_plans' do
    context 'without authentication' do
      subject { response.status }

      before { get shop_plans_v1_food_path(food1) }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      context 'with own foods' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user1)}" } }

        before { get shop_plans_v1_food_path(food1), headers: headers }

        it { is_expected.to eq(200) }
        it { assert_schema_conform }
      end

      context 'with other\'s food' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user1)}" } }

        before { get shop_plans_v1_food_path(food2), headers: headers }

        it { is_expected.to eq(404) }
        it { assert_schema_conform }
      end

      context 'with food in invited box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user1)}" } }

        before do
          Invitation.create(box: box2, user: user1)
          get shop_plans_v1_food_path(food2), headers: headers
        end

        it { is_expected.to eq(200) }
        it { assert_schema_conform }
      end
    end
  end

  describe 'GET /foods/:id/image' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit) { create(:unit, user: user) }
    let(:food) { create(:food, :with_image, box: box, unit: unit, created_user: user, updated_user: user) }
    let(:no_image_food) { create(:food, box: box, unit: unit, created_user: user, updated_user: user) }

    context 'without authentication' do
      subject { response.status }

      before { get image_v1_food_path(food) }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      context 'with image' do
        subject { response.status }

        before { get image_v1_food_path(food), headers: { authorization: "Bearer #{token(user)}" } }

        it { is_expected.to eq(200) }
      end

      context 'with no image' do
        subject { response.status }

        before { get image_v1_food_path(no_image_food), headers: { authorization: "Bearer #{token(user)}" } }

        it { is_expected.to eq(404) }
      end

      context 'with base64 requested param' do
        subject { response.status }

        before { get image_v1_food_path(food), headers: { authorization: "Bearer #{token(user)}" }, params: { base64: true } }

        it { is_expected.to eq(200) }
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
