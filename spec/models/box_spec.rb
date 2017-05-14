require 'rails_helper'

RSpec.describe Box, type: :model do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:box1) { create(:box, user: user1) }
  let!(:box2) { create(:box, user: user2) }

  before(:each) do
    Invitation.create(box: box1, user: user2)
  end

  describe 'scope' do
    describe 'owned_by' do
      subject(:boxes) { Box.owned_by(user1) }
      it { is_expected.to eq([box1]) }
    end

    describe 'inviting' do
      subject(:boxes) { Box.inviting(user2) }
      it { is_expected.to eq([box1]) }
    end

    describe 'all_with_invited' do
      subject(:boxes) { Box.all_with_invited(user2) }
      it { is_expected.to match_array([box1, box2]) }
    end
  end

  describe '#is_owned_by' do
    context 'with box owned by user' do
      subject(:owns) { box1.is_owned_by(user1) }
      it { is_expected.to be(true) }
    end

    context 'with box not owned by user' do
      subject(:owns) { box2.is_owned_by(user1) }
      it { is_expected.to be(false) }
    end

    context 'with box inviting user' do
      subject(:owns) { box1.is_owned_by(user2) }
      it { is_expected.to be(true) }
    end
  end

  describe '#is_inviting' do
    context 'with box owned by user' do
      subject(:inviting) { box1.is_inviting(user1) }
      it { is_expected.to be(false) }
    end

    context 'with box not owned by user' do
      subject(:inviting) { box2.is_inviting(user1) }
      it { is_expected.to be(false) }
    end

    context 'with box inviting user' do
      subject(:inviting) { box1.is_inviting(user2) }
      it { is_expected.to be(true) }
    end
  end

  describe '#is_accesable' do
    context 'with box owned by user' do
      subject(:accesable) { box1.is_accesable(user1) }
      it { is_expected.to be(true) }
    end

    context 'with box not owned by user' do
      subject(:accesable) { box2.is_accesable(user1) }
      it { is_expected.to be(false) }
    end

    context 'with box inviting user' do
      subject(:accesable) { box1.is_accesable(user2) }
      it { is_expected.to be(true) }
    end
  end
end
