# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::ShopPlansController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1/shop_plans').to route_to('v1/shop_plans#index')
    end

    it 'routes to #show' do
      expect(get: '/v1/shop_plans/1').to route_to('v1/shop_plans#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/v1/shop_plans').to route_to('v1/shop_plans#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/v1/shop_plans/1').to route_to('v1/shop_plans#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/v1/shop_plans/1').to route_to('v1/shop_plans#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/v1/shop_plans/1').to route_to('v1/shop_plans#destroy', id: '1')
    end
  end
end
