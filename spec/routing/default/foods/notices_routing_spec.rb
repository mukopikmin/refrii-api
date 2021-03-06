# frozen_string_literal: true

require 'rails_helper'

version = 'v1'

RSpec.describe "#{version.upcase}::Foods::NoticesController", type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/foods/1/notices').to route_to("#{version}/foods/notices#create", food_id: '1')
    end
  end
end
