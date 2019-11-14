# frozen_string_literal: true

require 'rails_helper'

version = 'v1'

RSpec.describe V1::Foods::ShopPlansController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/foods/1/shop_plans').to route_to("#{version}/foods/shop_plans#index", food_id: '1')
    end
  end
end
