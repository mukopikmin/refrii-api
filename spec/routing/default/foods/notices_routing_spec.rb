# frozen_string_literal: true

require 'rails_helper'

version = 'v1'

RSpec.describe "#{version.upcase}::Foods::NoticesController", type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/foods/1/notices').to route_to("#{version}/foods/notices#create", food_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/foods/1/notices/1').to route_to("#{version}/foods/notices#destroy", food_id: '1', id: '1')
    end
  end
end
