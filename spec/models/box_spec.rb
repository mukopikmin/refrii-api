# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Box, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:box1) { create(:box, owner: user1) }
  let!(:box2) { create(:box, owner: user2) }

  before { Invitation.create(box: box1, user: user2) }

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

  describe '#owned_by?' do
    context 'with box owned by user' do
      subject(:owns) { box1.owned_by?(user1) }

      it { is_expected.to be_truthy }
    end

    context 'with box not owned by user' do
      subject(:owns) { box2.owned_by?(user1) }

      it { is_expected.to be_falsey }
    end
  end

  describe '#inviting?' do
    context 'with box owned by user' do
      subject(:inviting) { box1.inviting?(user1) }

      it { is_expected.to be_falsey }
    end

    context 'with box not owned by user' do
      subject(:inviting) { box2.inviting?(user1) }

      it { is_expected.to be_falsey }
    end

    context 'with box inviting user' do
      subject(:inviting) { box1.inviting?(user2) }

      it { is_expected.to be_truthy }
    end
  end

  describe '#accessible_for?' do
    context 'with box owned by user' do
      subject(:accesable) { box1.accessible_for?(user1) }

      it { is_expected.to be_truthy }
    end

    context 'with box not owned by user' do
      subject(:accesable) { box2.accessible_for?(user1) }

      it { is_expected.to be_falsey }
    end

    context 'with box inviting user' do
      subject(:accesable) { box1.accessible_for?(user2) }

      it { is_expected.to be_truthy }
    end
  end

  describe '#revert' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:name_after) { 'after box' }

    context 'with versions' do
      subject { box.revert }

      before { box.update(name: name_after) }

      it { is_expected.to be_truthy }
    end

    context 'with no versions' do
      subject { box.revert }

      it { is_expected.to be_falsey }
    end
  end
end
