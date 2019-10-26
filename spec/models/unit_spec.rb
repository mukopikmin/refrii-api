# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Unit, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:unit1) { create(:unit, user: user1) }

  describe '.new' do
    context 'with same label, different user' do
      let(:unit) { build(:unit, label: 'label', user: user2) }

      before { create(:unit, label: 'label', user: user1) }

      it 'returns true on save' do
        expect(unit.save).to be_truthy
      end
    end

    context 'with same label and user' do
      let(:unit) { build(:unit, label: 'label', user: user1) }

      before { create(:unit, label: 'label', user: user1) }

      it 'returns false on save' do
        expect(unit.save).to be_falsey
      end
    end
  end

  describe 'scope' do
    describe 'owned_by' do
      subject(:units) { described_class.owned_by(user1) }

      it { is_expected.to eq([unit1]) }
    end
  end

  describe '#owned_by?' do
    context 'with unit owned' do
      subject { unit1.owned_by?(user1) }

      it { is_expected.to be_truthy }
    end

    context 'with unit not owned' do
      subject { unit1.owned_by?(user2) }

      it { is_expected.to be_falsey }
    end
  end

  describe '#inuse?' do
    context 'with units not referenced by foods' do
      subject { unit1.inuse? }

      it { is_expected.to be_falsey }
    end

    context 'with units referenced by foods' do
      subject { unit1.inuse? }

      let(:box) { create(:box, owner: user1) }

      before { create(:food, unit: unit1, box: box, created_user: user1, updated_user: user1) }

      it { is_expected.to be_truthy }
    end
  end
end
