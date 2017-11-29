require 'rails_helper'

RSpec.describe Food, type: :model do
  let(:user) { create(:user) }
  let(:box) { create(:box, owner: user) }
  let(:unit) { create(:unit, user: user) }
  let(:food) { create(:food, :with_image, box: box, unit: unit, created_user: user, updated_user: user) }
  let(:no_image_food) { create(:food, box: box, unit: unit, created_user: user, updated_user: user) }

  describe '#has_image?' do
    context 'if image exists' do
      subject { food.has_image? }

      it 'returns true' do
        is_expected.to be_truthy
      end
    end

    context 'if no image exists' do
      subject { no_image_food.has_image? }

      it 'returns false' do
        is_expected.to be_falsey
      end
    end
  end

  describe '#base64_image' do
    let(:user) { create(:user) }
    let(:box) { create(:box, :with_image, owner: user) }
    let(:unit) { create(:unit, user: user) }

    context 'if image exists' do
      let(:food) { create(:food, :with_image, box: box, unit: unit, created_user: user, updated_user: user) }

      it "returns image encoded by base64" do
        expect(food.base64_image[:base64]).to be_a(String)
      end
    end

    context 'if no image exists' do
      let(:no_image_food) { create(:food, box: box, unit: unit, created_user: user, updated_user: user) }

      it "returns nil" do
        expect(no_image_food.base64_image).to be_nil
      end
    end
  end
end
