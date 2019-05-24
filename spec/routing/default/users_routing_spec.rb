# frozen_string_literal: true

require 'rails_helper'

version = 'v1'

RSpec.describe "#{version.upcase}::UsersController", type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/users').to route_to("#{version}/users#index")
    end

    it 'routes to #show' do
      expect(get: '/users/1').to route_to("#{version}/users#show", id: '1')
    end

    it 'routes to #create' do
      expect(post: '/users').to route_to("#{version}/users#create")
    end

    it 'routes to #update via PUT' do
      expect(put: '/users/1').to route_to("#{version}/users#update", id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/users/1').to route_to("#{version}/users#update", id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/users/1').to route_to("#{version}/users#destroy", id: '1')
    end

    it 'routes to #push_token' do
      expect(post: '/v1/users/1/push_token').to route_to("#{version}/users#push_token", id: '1')
    end
  end
end
