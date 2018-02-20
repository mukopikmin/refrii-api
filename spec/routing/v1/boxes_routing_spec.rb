require 'rails_helper'

RSpec.describe V1::BoxesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1/boxes').to route_to('v1/boxes#index')
    end

    it 'routes to #owns' do
      expect(get: '/v1/boxes/owns').to route_to('v1/boxes#owns')
    end

    it 'routes to #invited' do
      expect(get: '/v1/boxes/invited').to route_to('v1/boxes#invited')
    end

    it 'routes to #show' do
      expect(get: '/v1/boxes/1').to route_to('v1/boxes#show', id: '1')
    end

    it 'routes to #image' do
      expect(get: '/v1/boxes/1/image').to route_to('v1/boxes#image', id: '1')
    end

    it 'routes to #units' do
      expect(get: '/v1/boxes/1/units').to route_to('v1/boxes#units', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/v1/boxes').to route_to('v1/boxes#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/v1/boxes/1').to route_to('v1/boxes#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/v1/boxes/1').to route_to('v1/boxes#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/v1/boxes/1').to route_to('v1/boxes#destroy', id: '1')
    end

    it 'routes to #invite' do
      expect(post: '/v1/boxes/1/invite').to route_to('v1/boxes#invite', id: '1')
    end

    it 'routes to #deinvite' do
      expect(delete: '/v1/boxes/1/invite').to route_to('v1/boxes#deinvite', id: '1')
    end
  end
end
