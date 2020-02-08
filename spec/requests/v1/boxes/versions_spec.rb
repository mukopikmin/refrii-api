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
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
