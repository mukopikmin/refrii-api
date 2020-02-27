# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShopPlans', type: :request do
  include Committee::Rails::Test::Methods

  let(:food) { create(:food, :with_box_user_unit) }
  let(:invited_food) { create(:food, :with_box_user_unit) }
  let(:invisible_food) { create(:food, :with_box_user_unit) }
  let!(:plan) { create(:shop_plan, food: food) }
  let!(:invited_plan) { create(:shop_plan, food: invited_food) }
  let!(:invisible_plan) { create(:shop_plan, food: invisible_food) }
  let(:user) { food.box.owner }

  before { Invitation.create(box: invited_food.box, user: user) }

  describe 'GET /shop_plans' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_shop_plans_path }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authnetication' do
      subject { response.status }

      let(:headers) { { authorization: "Bearer #{token(user)}" } }
      let(:result) { JSON.parse(response.body).map { |p| p['id'] } }

      before { get v1_shop_plans_path, headers: headers }

      it { is_expected.to eq(200) }
      it { assert_response_schema_confirm }

      it 'contains plans for owns and invited foods' do
        expect(result).to contain_exactly(plan.id, invited_plan.id)
      end
    end
  end

  describe 'GET /shop_plans/:id' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_shop_plan_path(plan) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authnetication' do
      context 'with shop plan of own foods' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { get v1_shop_plan_path(plan), headers: headers }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end

      context 'with shop plan of other\'s foods' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { get v1_shop_plan_path(invisible_plan), headers: headers }

        it { is_expected.to eq(404) }
        it { assert_response_schema_confirm }
      end

      context 'with shop plan of invited foods' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { get v1_shop_plan_path(invited_plan), headers: headers }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'POST /shop_plans' do
    context 'without authentication' do
      subject { response.status }

      before { post v1_shop_plans_path }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authnetication' do
      context 'with own food' do
        context 'with full filled params' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:shop_plan).merge(food_id: food.to_param) }

          before { post v1_shop_plans_path, headers: headers, params: params }

          it { is_expected.to eq(201) }
          it { assert_response_schema_confirm }
        end

        context 'with no amount' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:no_amount_shop_plan).merge(food_id: food.to_param) }

          before { post v1_shop_plans_path, headers: headers, params: params }

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end

        context 'with negative amount' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:shop_plan, :with_negative_amount).merge(food_id: food.to_param) }

          before { post v1_shop_plans_path, headers: headers, params: params }

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end

        context 'with no done state' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:no_done_shop_plan).merge(food_id: food.to_param) }

          before { post v1_shop_plans_path, headers: headers, params: params }

          it { is_expected.to eq(201) }
          it { assert_response_schema_confirm }
        end

        context 'with no date' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:no_date_shop_plan).merge(food_id: food.to_param) }

          before { post v1_shop_plans_path, headers: headers, params: params }

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end
      end

      context 'with other\'s food' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }
        let(:params) { attributes_for(:shop_plan).merge(food_id: invisible_food.to_param) }

        before { post v1_shop_plans_path, headers: headers, params: params }

        it { is_expected.to eq(403) }
        it { assert_response_schema_confirm }
      end

      context 'with food in invited box' do
        context 'with full filled params' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:shop_plan).merge(food_id: invited_food.to_param) }

          before { post v1_shop_plans_path, headers: headers, params: params }

          it { is_expected.to eq(201) }
          it { assert_response_schema_confirm }
        end

        context 'with no amount' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:no_amount_shop_plan).merge(food_id: invited_food.to_param) }

          before { post v1_shop_plans_path, headers: headers, params: params }

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end

        context 'with negative amount' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:shop_plan, :with_negative_amount).merge(food_id: invited_food.to_param) }

          before { post v1_shop_plans_path, headers: headers, params: params }

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end

        context 'with no done state' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:no_done_shop_plan).merge(food_id: invited_food.to_param) }

          before { post v1_shop_plans_path, headers: headers, params: params }

          it { is_expected.to eq(201) }
          it { assert_response_schema_confirm }
        end

        context 'with no date' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:no_date_shop_plan).merge(food_id: invited_food.to_param) }

          before { post v1_shop_plans_path, headers: headers, params: params }

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end
      end
    end
  end

  describe 'PUT /shop_plans/:id' do
    context 'without authentication' do
      subject { response.status }

      before { put v1_shop_plan_path(plan) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authnetication' do
      context 'with own food' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }
        let(:params) { attributes_for(:shop_plan) }

        before { put v1_shop_plan_path(plan), headers: headers, params: params }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s food' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }
        let(:params) { attributes_for(:shop_plan) }

        before { put v1_shop_plan_path(invisible_plan), headers: headers, params: params }

        it { is_expected.to eq(403) }
        it { assert_response_schema_confirm }
      end

      context 'with food in invited box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }
        let(:params) { attributes_for(:shop_plan) }

        before { put v1_shop_plan_path(invited_plan), headers: headers, params: params }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'DELETE /shop_plans/:id' do
    context 'without authentication' do
      subject { response.status }

      before { delete v1_shop_plan_path(plan) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authnetication' do
      context 'with own food' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { delete v1_shop_plan_path(plan), headers: headers }

        it { is_expected.to eq(204) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s food' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { delete v1_shop_plan_path(invisible_plan), headers: headers }

        it { is_expected.to eq(404) }
        it { assert_response_schema_confirm }
      end

      context 'with food in invited box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { delete v1_shop_plan_path(invited_plan), headers: headers }

        it { is_expected.to eq(204) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
