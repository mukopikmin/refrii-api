# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Foods/ShopPlans', type: :request do
  include Committee::Rails::Test::Methods

  let(:food) { create(:food, :with_box_user_unit) }
  let(:invited_food) { create(:food, :with_box_user_unit) }
  let(:invisible_food) { create(:food, :with_box_user_unit) }
  let!(:plan) { create(:shop_plan, food: food) }
  let!(:invited_plan) { create(:shop_plan, food: invited_food) }
  let!(:invisible_plan) { create(:shop_plan, food: invisible_food) }
  let(:user) { food.box.owner }

  before { Invitation.create(box: invited_food.box, user: user) }

  describe 'GET /foods/:id/shop_plans' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_food_shop_plans_path(food) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own foods' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }
        let(:result) { JSON.parse(response.body).map { |p| p['id'] } }

        before { get v1_food_shop_plans_path(food), headers: headers }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }

        it 'contains plans for owns foods' do
          expect(result).to contain_exactly(plan.id)
        end
      end

      context 'with other\'s food' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { get v1_food_shop_plans_path(invisible_food), headers: headers }

        it { is_expected.to eq(404) }
        it { assert_response_schema_confirm }
      end

      context 'with food in invited box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }
        let(:result) { JSON.parse(response.body).map { |p| p['id'] } }

        before do
          get v1_food_shop_plans_path(invited_food), headers: headers
        end

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }

        it 'contains plans for invited foods' do
          expect(result).to contain_exactly(invited_plan.id)
        end
      end
    end
  end

  describe 'POST /foods/:id/shop_plans' do
    context 'without authentication' do
      subject { response.status }

      before { post v1_food_shop_plans_path(food_id: food) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authnetication' do
      context 'with own food' do
        context 'with full filled params' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:shop_plan) }

          before { post v1_food_shop_plans_path(food_id: food), headers: headers, params: params }

          it { is_expected.to eq(201) }
          it { assert_response_schema_confirm }
        end

        context 'with no amount' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:no_amount_shop_plan) }

          before { post v1_food_shop_plans_path(food_id: food), headers: headers, params: params }

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end

        context 'with negative amount' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:shop_plan, :with_negative_amount) }

          before { post v1_food_shop_plans_path(food_id: food), headers: headers, params: params }

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end

        context 'with no done state' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:no_done_shop_plan) }

          before { post v1_food_shop_plans_path(food_id: food), headers: headers, params: params }

          it { is_expected.to eq(201) }
          it { assert_response_schema_confirm }
        end

        context 'with no date' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:no_date_shop_plan) }

          before { post v1_food_shop_plans_path(food_id: food), headers: headers, params: params }

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end
      end

      context 'with other\'s food' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }
        let(:params) { attributes_for(:shop_plan) }

        before { post v1_food_shop_plans_path(food_id: invisible_food), headers: headers, params: params }

        it { is_expected.to eq(403) }
        it { assert_response_schema_confirm }
      end

      context 'with food in invited box' do
        context 'with full filled params' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:shop_plan) }

          before { post v1_food_shop_plans_path(food_id: invited_food), headers: headers, params: params }

          it { is_expected.to eq(201) }
          it { assert_response_schema_confirm }
        end

        context 'with no amount' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:no_amount_shop_plan) }

          before { post v1_food_shop_plans_path(food_id: invited_food), headers: headers, params: params }

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end

        context 'with negative amount' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:shop_plan, :with_negative_amount) }

          before { post v1_food_shop_plans_path(food_id: invited_food), headers: headers, params: params }

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end

        context 'with no done state' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:no_done_shop_plan) }

          before { post v1_food_shop_plans_path(food_id: invited_food), headers: headers, params: params }

          it { is_expected.to eq(201) }
          it { assert_response_schema_confirm }
        end

        context 'with no date' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { attributes_for(:no_date_shop_plan) }

          before { post v1_food_shop_plans_path(food_id: invited_food), headers: headers, params: params }

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end
      end
    end
  end
end
