require 'rails_helper'

RSpec.describe AuthenticationController, type: :routing do
  describe 'routing' do
    it 'routes to #local' do
      expect(post: '/auth/local').to route_to('authentication#local')
    end

    it 'routes to #google' do
      expect(get: '/auth/google/callback').to route_to('authentication#google')
    end
  end
end
