# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Boxes/Versions', type: :request do
  include Committee::Rails::Test::Methods

  let(:box) { create(:box, :with_owner) }
  let(:invisible_box) { create(:box, :with_owner) }
  let(:invited_box) { create(:box, :with_owner) }
  let(:user) { box.owner }

  before { Invitation.create(box: invited_box, user: user) }

  describe 'GET /boxes/:id/versions' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_box_versions_path(box_id: box.id) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { get v1_box_versions_path(box_id: box.id), headers: headers }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end

      context 'with invited box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { get v1_box_versions_path(box_id: invited_box.id), headers: headers }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { get v1_box_versions_path(box_id: invisible_box.id), headers: headers }

        it { is_expected.to eq(404) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'POST /boxes/:id/version' do
    context 'without authentication' do
      subject { response.status }

      before { post v1_box_versions_path(box_id: box.id) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own box' do
        context 'with previous vesions' do
          subject { response.status }

          let(:name) { JSON.parse(response.body)['name'] }
          let(:headers) { { authorization: "Bearer #{token(user)}" } }

          before do
            box.update(name: 'updated')
            post v1_box_versions_path(box_id: box.id), headers: headers
          end

          it { is_expected.to eq(201) }
          it { assert_response_schema_confirm }

          it 'reverts to the previous version' do
            expect(name).not_to eq('updated')
          end
        end

        context 'without previous vesions' do
          subject { response.status }

          let(:box) { create(:box, :with_owner) }
          let(:headers) { { authorization: "Bearer #{token(user)}" } }

          before do
            post v1_box_versions_path(box_id: box.id), headers: headers
          end

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end
      end

      context 'with invited box' do
        subject { response.status }

        let(:box) { create(:box, :with_owner) }
        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before do
          post v1_box_versions_path(box_id: invited_box.id), headers: headers
        end

        it { is_expected.to eq(403) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s box' do
        subject { response.status }

        let(:box) { create(:box, :with_owner) }
        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before do
          post v1_box_versions_path(box_id: invited_box.id), headers: headers
        end

        it { is_expected.to eq(403) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
