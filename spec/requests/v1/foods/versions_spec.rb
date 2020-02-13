# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Foods/Versions', type: :request do
  include Committee::Rails::Test::Methods

  let(:food1) { create(:food, :with_box_user_unit) }
  let(:food2) { create(:food, :with_box_user_unit) }
  let(:user1) { food1.box.owner }

  describe 'GET /foods/:id/versions' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_food_versions_path(food1) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own foods' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user1)}" } }

        before { get v1_food_versions_path(food1), headers: headers }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s food' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user1)}" } }

        before { get v1_food_versions_path(food2), headers: headers }

        it { is_expected.to eq(404) }
        it { assert_response_schema_confirm }
      end

      context 'with food in invited box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user1)}" } }

        before do
          Invitation.create(box: food2.box, user: user1)
          get v1_food_versions_path(food2), headers: headers
        end

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'POST #create' do
    context 'with previous vesions' do
      subject { response.status }

      before do
        food1.update(name: 'with history')
        post v1_food_versions_path(food1), headers: headers
      end

      let(:headers) { { authorization: "Bearer #{token(user1)}" } }

      it { is_expected.to eq(201) }
      it { assert_response_schema_confirm }
    end

    context 'without previous versions' do
      subject { response.status }

      let(:headers) { { authorization: "Bearer #{token(user1)}" } }

      before do
        post v1_food_versions_path(food1), headers: headers
      end

      it { is_expected.to eq(400) }
      it { assert_response_schema_confirm }
    end
  end
end
