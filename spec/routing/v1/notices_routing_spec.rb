# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Foods::NoticesController, type: :routing do
  describe 'routing' do
    it 'routes to #destroy' do
      expect(delete: '/notices/1').to route_to('v1/notices#destroy', id: '1')
    end
  end
end
