# frozen_string_literal: true

require 'rails_helper'

version = 'v1'

RSpec.describe V1::Foods::VersionsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/foods/1/versions').to route_to("#{version}/foods/versions#index", food_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/foods/1/versions').to route_to("#{version}/foods/versions#create", food_id: '1')
    end
  end
end
