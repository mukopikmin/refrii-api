# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShopPlan, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:box1) { create(:box, owner: user1) }
  let(:box2) { create(:box, owner: user2) }
  let(:unit1) { create(:unit, user: user1) }
  let(:unit2) { create(:unit, user: user2) }
  let(:food1) { create(:food, unit: unit1, box: box1, created_user: user1, updated_user: user1) }
  let(:food2) { create(:food, unit: unit2, box: box2, created_user: user2, updated_user: user2) }
  let!(:plan1) { create(:shop_plan, food: food1) }
  let!(:plan2) { create(:shop_plan, food: food2) }

  describe '.all_with_invited' do
    context 'without invitation' do
      subject { ShopPlan.all_with_invited(user1) }

      it { is_expected.to eq([plan1]) }
    end

    context 'with invitations' do
      subject { ShopPlan.all_with_invited(user1) }

      before { Invitation.create(box: box2, user: user1) }

      it { is_expected.to eq([plan1, plan2]) }
    end
  end

  describe '#accessible_for?' do
    context 'with own shop plans' do
      subject { plan1.accessible_for?(user1) }

      it { is_expected.to be_truthy }
    end

    context 'with other\'s shop plans' do
      subject { plan1.accessible_for?(user2) }

      it { is_expected.to be_falsey }
    end

    context 'with shop plans for foods in invited box' do
      subject { plan2.accessible_for?(user1) }

      before { Invitation.create(box: box2, user: user1) }

      it { is_expected.to be_truthy }
    end
  end

  describe '#complete' do
    let!(:amount) { plan1.food.amount + plan1.amount }

    before { plan1.complete }

    it 'changes done to true' do
      expect(plan1.done).to be_truthy
    end

    it 'updates amount of referenced food' do
      expect(plan1.food.amount).to eq(amount)
    end
  end
end
