# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Food, type: :model do
  describe '.all_with_invited' do
    subject { Food.all_with_invited(user1).size }

    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:box1) { create(:box, owner: user1) }
    let(:box2) { create(:box, owner: user2) }
    let(:unit1) { create(:unit, user: user1) }
    let(:unit2) { create(:unit, user: user2) }

    before do
      create(:food, box: box1, unit: unit1, created_user: user1, updated_user: user1)
      create(:food, box: box2, unit: unit2, created_user: user2, updated_user: user2)
    end

    before { Invitation.create(box: box2, user: user1) }

    it { is_expected.to eq(2) }
  end

  describe '#assignable_units' do
    subject { food.assignable_units }

    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit1) { create(:unit, user: user) }
    let(:unit2) { create(:unit, user: user) }
    let(:food) { create(:food, :with_image, box: box, unit: unit1, created_user: user, updated_user: user) }

    it { is_expected.to eq([unit1, unit2]) }
  end

  describe '#revert' do
    let(:user) { create(:user) }
    let(:box) { create(:box, name: name_before, owner: user) }
    let(:unit) { create(:unit, user: user) }
    let(:food) { create(:food, name: name_before, box: box, unit: unit, created_user: user, updated_user: user) }
    let(:name_before) { 'before food' }

    context 'with versions' do
      let(:name_after) { 'after food' }

      before { food.update(name: name_after) }

      it 'returns previous version' do
        expect(food.revert.name).to eq(name_before)
      end
    end

    context 'with no versions' do
      subject { food.revert }

      it { is_expected.to be_nil }
    end
  end
end
