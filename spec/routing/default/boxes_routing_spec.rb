require 'rails_helper'

version = 'v1'

RSpec.describe "#{version.upcase}::BoxesController", type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/boxes').to route_to("#{version}/boxes#index")
    end

    it 'routes to #owns' do
      expect(get: '/boxes/owns').to route_to("#{version}/boxes#owns")
    end

    it 'routes to #invited' do
      expect(get: '/boxes/invited').to route_to("#{version}/boxes#invited")
    end

    it 'routes to #show' do
      expect(get: '/boxes/1').to route_to("#{version}/boxes#show", id: '1')
    end

    it 'routes to #image' do
      expect(get: '/boxes/1/image').to route_to("#{version}/boxes#image", id: '1')
    end

    it 'routes to #units' do
      expect(get: '/boxes/1/units').to route_to("#{version}/boxes#units", id: '1')
    end

    it 'routes to #create' do
      expect(post: '/boxes').to route_to("#{version}/boxes#create")
    end

    it 'routes to #update via PUT' do
      expect(put: '/boxes/1').to route_to("#{version}/boxes#update", id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/boxes/1').to route_to("#{version}/boxes#update", id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/boxes/1').to route_to("#{version}/boxes#destroy", id: '1')
    end

    it 'routes to #invite' do
      expect(post: '/boxes/1/invite').to route_to("#{version}/boxes#invite", id: '1')
    end

    it 'routes to #deinvite' do
      expect(delete: '/boxes/1/invite').to route_to("#{version}/boxes#deinvite", id: '1')
    end
  end
end