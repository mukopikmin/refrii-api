# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Foods', type: :request do
  include Committee::Rails::Test::Methods

  let(:food) { create(:food, :with_box_user_unit) }
  let(:invited_food) { create(:food, :with_box_user_unit) }
  let(:invisible_food) { create(:food, :with_box_user_unit) }
  let(:user) { food.box.owner }

  before do
    Invitation.create(box: invited_food.box, user: user)
    create(:notice, food: food,
                    created_user: user,
                    updated_user: user)
  end

  describe 'GET /foods' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_foods_path }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      subject { response.status }

      let(:headers) { { authorization: "Bearer #{token(user)}" } }
      let(:body) { JSON.parse(response.body) }
      let(:result) { body.map { |food| food['box']['is_invited'] } }

      before { get v1_foods_path, headers: headers }

      it { is_expected.to eq(200) }
      it { assert_response_schema_confirm }

      it 'returns all foods' do
        expect(result).to include(be_truthy)
        expect(result).to include(be_falsey)
      end
    end
  end

  describe 'GET /foods/:id' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_food_path(food) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with food in own box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { get v1_food_path(food), headers: headers }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end

      context 'with food in invited box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { get v1_food_path(invited_food), headers: headers }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end

      context 'with food in other\'s box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { get v1_food_path(invisible_food), headers: headers }

        it { is_expected.to eq(404) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'POST /foods' do
    context 'without authentication' do
      subject { response.status }

      let(:valid_params) do
        attributes_for(:food).merge(box_id: food.box.to_param,
                                    unit_id: food.unit.to_param)
      end

      before { post v1_foods_path, params: valid_params }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with food in own box' do
        context 'with valid params' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:valid_params) do
            attributes_for(:food).merge(box_id: food.box.to_param,
                                        unit_id: food.unit.to_param)
          end

          before { post v1_foods_path, params: valid_params, headers: headers }

          it { is_expected.to eq(201) }
          it { assert_response_schema_confirm }
        end

        context 'with invalid params' do
          context 'with no name food' do
            subject { response.status }

            let(:params) { attributes_for(:no_name_food).merge(box_id: food.box.to_param, unit_id: food.unit.to_param) }
            let(:headers) { { authorization: "Bearer #{token(user)}" } }

            before { post v1_foods_path, params: params, headers: headers }

            it { is_expected.to eq(400) }
            it { assert_response_schema_confirm }
          end

          context 'with unit for box owned by other users' do
            subject { response.status }

            let(:params) { { box_id: food.box.to_param, unit_id: invisible_food.unit.to_param } }
            let(:headers) { { authorization: "Bearer #{token(user)}" } }

            before { post v1_foods_path, params: params, headers: headers }

            it { is_expected.to eq(400) }
            it { assert_response_schema_confirm }
          end
        end
      end

      context 'with food in invited box' do
        context 'with valid params' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:valid_params) do
            attributes_for(:food).merge(box_id: invited_food.box.to_param,
                                        unit_id: invited_food.unit.to_param)
          end

          before { post v1_foods_path, params: valid_params, headers: headers }

          it { is_expected.to eq(201) }
          it { assert_response_schema_confirm }
        end

        context 'with invalid params' do
          context 'with no name food' do
            subject { response.status }

            let(:params) do
              attributes_for(:no_name_food).merge(box_id: invited_food.box.to_param,
                                                  unit_id: invited_food.unit.to_param)
            end
            let(:headers) { { authorization: "Bearer #{token(user)}" } }

            before { post v1_foods_path, params: params, headers: headers }

            it { is_expected.to eq(400) }
            it { assert_response_schema_confirm }
          end

          context 'with unit for box owned by other users' do
            subject { response.status }

            let(:params) do
              {
                box_id: invited_food.box.to_param,
                unit_id: invisible_food.unit.to_param
              }
            end
            let(:headers) { { authorization: "Bearer #{token(user)}" } }

            before { post v1_foods_path, params: params, headers: headers }

            it { is_expected.to eq(400) }
            it { assert_response_schema_confirm }
          end
        end
      end

      context 'with food in other\'s box' do
        subject { response.status }

        let(:params) do
          attributes_for(:food).merge(box_id: invisible_food.box.to_param,
                                      unit_id: invisible_food.unit.to_param)
        end
        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { post v1_foods_path, params: params, headers: headers }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'PUT /foods/:id' do
    let(:params) { attributes_for(:food) }

    context 'without authentication' do
      subject { response.status }

      before { put v1_food_path(food), params: params }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with food in own box' do
        context 'with valid params' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }

          before { put v1_food_path(food), params: params, headers: headers }

          it { is_expected.to eq(200) }
          it { assert_response_schema_confirm }
        end

        context 'with invalid params' do
          context 'with no name food' do
            subject { response.status }

            let(:no_name_params) { attributes_for(:no_name_food) }

            let(:headers) { { authorization: "Bearer #{token(user)}" } }

            before { put v1_food_path(food), params: no_name_params, headers: headers }

            it { is_expected.to eq(400) }
            it { assert_response_schema_confirm }
          end

          context 'with unit for box owned by other users' do
            subject { response.status }

            let(:params) { { unit_id: invisible_food.unit.to_param } }
            let(:headers) { { authorization: "Bearer #{token(user)}" } }

            before { put v1_food_path(food), params: params, headers: headers }

            it { is_expected.to eq(400) }
            it { assert_response_schema_confirm }
          end
        end
      end

      context 'with food in invited box' do
        context 'with valid params' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }

          before { put v1_food_path(invited_food), params: params, headers: headers }

          it { is_expected.to eq(200) }
          it { assert_response_schema_confirm }
        end

        context 'with invalid params' do
          context 'with no name food' do
            subject { response.status }

            let(:no_name_params) { attributes_for(:no_name_food) }

            let(:headers) { { authorization: "Bearer #{token(user)}" } }

            before { put v1_food_path(invited_food), params: no_name_params, headers: headers }

            it { is_expected.to eq(400) }
            it { assert_response_schema_confirm }
          end

          context 'with unit for box owned by other users' do
            subject { response.status }

            let(:params) { { unit_id: invisible_food.unit.to_param } }
            let(:headers) { { authorization: "Bearer #{token(user)}" } }

            before { put v1_food_path(invited_food), params: params, headers: headers }

            it { is_expected.to eq(400) }
            it { assert_response_schema_confirm }
          end
        end
      end

      context 'with food in other\'s box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { put v1_food_path(invisible_food), params: params, headers: headers }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'DELETE /foods/:id' do
    context 'without authentication' do
      subject { response.status }

      before { delete v1_food_path(food) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with food in own box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { delete v1_food_path(food), headers: headers }

        it { is_expected.to eq(204) }
        it { assert_response_schema_confirm }
      end

      context 'with food in invited box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { delete v1_food_path(invited_food), headers: headers }

        it { is_expected.to eq(204) }
        it { assert_response_schema_confirm }
      end

      context 'with food in other\'s box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { delete v1_food_path(invisible_food), headers: headers }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end

      context 'with food with notices' do
        subject { response.status }

        let(:food) { create(:food, :with_box_user_unit) }

        let(:user) { food.box.owner }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before do
          create(:notice, created_user: user, updated_user: user, food: food)
          delete v1_food_path(food), headers: headers
        end

        it { is_expected.to eq(204) }
        it { assert_response_schema_confirm }
      end

      context 'with food with shop plans' do
        subject { response.status }

        let(:food) { create(:food, :with_box_user_unit) }

        let(:user) { food.box.owner }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before do
          create(:shop_plan, food: food)
          delete v1_food_path(food), headers: headers
        end

        it { is_expected.to eq(204) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
