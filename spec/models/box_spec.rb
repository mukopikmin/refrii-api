# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Box, type: :model do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:box1) { create(:box, owner: user1) }
  let!(:box2) { create(:box, owner: user2) }

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

  describe '#image_exists?' do
    let(:user) { create(:user) }

    context 'if image exists' do
      let(:box) { create(:box, :with_image, owner: user) }
      subject { box.image_exists? }

      it 'returns true' do
        is_expected.to be_truthy
      end
    end

    context 'if no image exists' do
      let(:no_image_box) { create(:box, owner: user) }
      subject { no_image_box.image_exists? }

      it 'returns false' do
        is_expected.to be_falsey
      end
    end
  end

  describe '#base64_image' do
    let(:user) { create(:user) }

    context 'if image exists' do
      let(:box) { create(:box, :with_image, owner: user) }

      it 'returns image encoded by base64' do
        expect(box.base64_image[:base64]).to be_a(String)
      end
    end

    context 'if no image exists' do
      let(:no_image_box) { create(:box, owner: user) }

      it 'returns nil' do
        expect(no_image_box.base64_image).to be_nil
      end
    end
  end

  describe '#revert' do
    let(:user) { create(:user) }
    let(:box) { create(:box, name: name_before, owner: user) }
    let(:name_before) { 'before box' }
    let(:name_after) { 'after box' }

    context 'with versions' do
      before(:each) { box.update(name: name_after) }

      it 'returns previous version' do
        expect(box.revert.name).to eq(name_before)
      end
    end

    context 'with no versions' do
      it 'returns nil' do
        expect(box.revert).to be_nil
      end
    end
  end
end
