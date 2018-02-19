require 'rails_helper'

RSpec.describe V1::UnitsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1/units').to route_to('v1/units#index')
    end

    it 'routes to #show' do
      expect(get: '/v1/units/1').to route_to('v1/units#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/v1/units').to route_to('v1/units#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/v1/units/1').to route_to('v1/units#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/v1/units/1').to route_to('v1/units#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/v1/units/1').to route_to('v1/units#destroy', id: '1')
    end
  end
end
