# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Foods/ShopPlans', type: :request do
  include Committee::Rails::Test::Methods

  let(:food) { create(:food, :with_box_user_unit) }
  let(:invited_food) { create(:food, :with_box_user_unit) }
  let(:invisible_food) { create(:food, :with_box_user_unit) }
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

        before { get v1_food_shop_plans_path(food), headers: headers }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
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

        before do
          get v1_food_shop_plans_path(invited_food), headers: headers
        end

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
