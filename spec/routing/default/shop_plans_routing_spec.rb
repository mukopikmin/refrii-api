# frozen_string_literal: true

require 'rails_helper'

version = 'v1'

RSpec.describe "#{version.upcase}::ShopPlansController", type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/shop_plans').to route_to("#{version}/shop_plans#index")
    end

    it 'routes to #show' do
      expect(get: '/shop_plans/1').to route_to("#{version}/shop_plans#show", id: '1')
    end

    it 'routes to #create' do
      expect(post: '/shop_plans').to route_to("#{version}/shop_plans#create")
    end

    it 'routes to #update via PUT' do
      expect(put: '/shop_plans/1').to route_to("#{version}/shop_plans#update", id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/shop_plans/1').to route_to("#{version}/shop_plans#update", id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/shop_plans/1').to route_to("#{version}/shop_plans#destroy", id: '1')
    end
  end
end
