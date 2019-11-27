# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Boxes', type: :request do
  include Committee::Rails::Test::Methods

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:box1) { create(:box, owner: user1) }
  let!(:box2) { create(:box, owner: user2) }
  let!(:box3) { create(:box, owner: user2) }

  before { Invitation.create(box: box3, user: user1) }

  describe 'GET /boxes/:id/units' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_box_units_path(box1) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own box' do
        subject { response.status }

        before { get v1_box_units_path(box1), headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s box' do
        subject { response.status }

        before do
          get v1_box_units_path(box2), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(404) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
