# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Foods/Versions', type: :request do
  include Committee::Rails::Test::Methods

  describe 'GET /foods/:id/versions' do
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

    context 'without authentication' do
      subject { response.status }

      before { get v1_food_versions_path(food1) }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      context 'with own foods' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user1)}" } }

        before { get v1_food_versions_path(food1), headers: headers }

        it { is_expected.to eq(200) }
        it { assert_schema_conform }
      end

      context 'with other\'s food' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user1)}" } }

        before { get v1_food_versions_path(food2), headers: headers }

        it { is_expected.to eq(404) }
        it { assert_schema_conform }
      end

      context 'with food in invited box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user1)}" } }

        before do
          Invitation.create(box: box2, user: user1)
          get v1_food_versions_path(food2), headers: headers
        end

        it { is_expected.to eq(200) }
        it { assert_schema_conform }
      end
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit) { create(:unit, user: user) }
    let(:food) do
      create(:food, box: box,
                    unit: unit,
                    created_user: box.owner,
                    updated_user: box.owner)
    end

    context 'with previous vesions' do
      subject { response.status }

      before do
        food.update(name: 'with history')
        post v1_food_versions_path(food), headers: headers
      end

      let(:headers) { { authorization: "Bearer #{token(user)}" } }

      it { is_expected.to eq(201) }
      it { assert_schema_conform }
    end

    context 'without previous versions' do
      subject { response.status }

      let(:headers) { { authorization: "Bearer #{token(user)}" } }

      before do
        post v1_food_versions_path(food), headers: headers
      end

      it { is_expected.to eq(400) }
      it { assert_schema_conform }
    end
  end
end
