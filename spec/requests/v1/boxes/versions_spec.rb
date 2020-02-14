# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Boxes/Versions', type: :request do
  include Committee::Rails::Test::Methods

  let!(:box1) { create(:box, :with_owner) }
  let!(:box2) { create(:box, :with_owner) }
  let!(:box3) { create(:box, :with_owner) }

  before { Invitation.create(box: box3, user: box1.owner) }

  describe 'GET /boxes/:id/versions' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_box_versions_path(box_id: box1.id) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      subject { response.status }

      let(:headers) { { authorization: "Bearer #{token(box1.owner)}" } }

      before { get v1_box_versions_path(box_id: box1.id), headers: headers }

      it { is_expected.to eq(200) }
      it { assert_response_schema_confirm }
    end
  end

  describe 'POST /boxes/:id/version' do
    context 'without authentication' do
      subject { response.status }

      before { post v1_box_versions_path(box_id: box1.id) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with previous vesions' do
        subject { response.status }

        let(:name) { JSON.parse(response.body)['name'] }
        let(:headers) { { authorization: "Bearer #{token(box1.owner)}" } }

        before do
          box1.update(name: 'updated')
          post v1_box_versions_path(box_id: box1.id), headers: headers
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
        let(:headers) { { authorization: "Bearer #{token(box1.owner)}" } }

        before do
          post v1_box_versions_path(box_id: box.id), headers: headers
        end

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
