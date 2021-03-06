# frozen_string_literal: true

require 'rails_helper'

version = 'v1'

RSpec.describe "#{version.upcase}::FoodsController", type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/foods').to route_to("#{version}/foods#index")
    end

    it 'routes to #show' do
      expect(get: '/foods/1').to route_to("#{version}/foods#show", id: '1')
    end

    it 'routes to #create' do
      expect(post: '/foods').to route_to("#{version}/foods#create")
    end

    it 'routes to #update via PUT' do
      expect(put: '/foods/1').to route_to("#{version}/foods#update", id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/foods/1').to route_to("#{version}/foods#update", id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/foods/1').to route_to("#{version}/foods#destroy", id: '1')
    end
  end
end
