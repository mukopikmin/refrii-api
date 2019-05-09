# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::FoodsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1/foods').to route_to('v1/foods#index')
    end

    it 'routes to #show' do
      expect(get: '/v1/foods/1').to route_to('v1/foods#show', id: '1')
    end

    it 'routes to #versions' do
      expect(get: '/foods/1/versions').to route_to('v1/foods#versions', id: '1')
    end

    it 'routes to #shop_plans' do
      expect(get: '/foods/1/shop_plans').to route_to('v1/foods#shop_plans', id: '1')
    end

    it 'routes to #image' do
      expect(get: '/v1/foods/1/image').to route_to('v1/foods#image', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/v1/foods').to route_to('v1/foods#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/v1/foods/1').to route_to('v1/foods#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/v1/foods/1').to route_to('v1/foods#update', id: '1')
    end

    it 'routes to #revert via PUT' do
      expect(put: '/v1/foods/1/revert').to route_to('v1/foods#revert', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/v1/foods/1').to route_to('v1/foods#destroy', id: '1')
    end
  end
end
