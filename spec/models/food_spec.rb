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
    let!(:food1) { create(:food, box: box1, unit: unit1, created_user: user1, updated_user: user1) }
    let!(:food2) { create(:food, box: box2, unit: unit2, created_user: user2, updated_user: user2) }

    before { Invitation.create(box: box2, user: user1) }

    it { is_expected.to eq(2) }
  end

  describe '#image_exists?' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit) { create(:unit, user: user) }

    context 'when image exists' do
      subject { food.image_exists? }

      let(:food) { create(:food, :with_image, box: box, unit: unit, created_user: user, updated_user: user) }

      it { is_expected.to be_truthy }
    end

    context 'when no image exists' do
      subject { no_image_food.image_exists? }

      let(:no_image_food) { create(:food, box: box, unit: unit, created_user: user, updated_user: user) }

      it { is_expected.to be_falsey }
    end
  end

  describe '#base64_image' do
    let(:user) { create(:user) }
    let(:box) { create(:box, :with_image, owner: user) }
    let(:unit) { create(:unit, user: user) }

    context 'when image exists' do
      let(:food) { create(:food, :with_image, box: box, unit: unit, created_user: user, updated_user: user) }

      it 'returns image encoded by base64' do
        expect(food.base64_image[:base64]).to be_a(String)
      end
    end

    context 'when no image exists' do
      let(:no_image_food) { create(:food, box: box, unit: unit, created_user: user, updated_user: user) }

      it 'returns nil' do
        expect(no_image_food.base64_image).to be_nil
      end
    end
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
