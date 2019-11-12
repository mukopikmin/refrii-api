# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Boxes/Versions', type: :request do
  include Committee::Rails::Test::Methods

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:box1) { create(:box, owner: user1) }
  let!(:box2) { create(:box, owner: user2) }
  let!(:box3) { create(:box, owner: user2) }

  before { Invitation.create(box: box3, user: user1) }

  describe 'GET /boxes/:id/versions' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_box_versions_path(box_id: box1.id) }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      subject { response.status }

      let(:headers) { { authorization: "Bearer #{token(user1)}" } }

      before { get v1_box_versions_path(box_id: box1.id), headers: headers }

      it { is_expected.to eq(200) }
      it { assert_schema_conform }
    end
  end

  describe 'POST /boxes/:id/version' do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
