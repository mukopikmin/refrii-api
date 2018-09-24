# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::AuthenticationController, type: :routing do
  describe 'routing' do
    it 'routes to #local' do
      expect(post: '/v1/auth/local').to route_to('v1/authentication#local')
    end

    it 'routes to #google' do
      expect(get: '/v1/auth/google/callback').to route_to('v1/authentication#google')
    end

    it 'routes to #google_token' do
      expect(get: '/v1/auth/google/token').to route_to('v1/authentication#google_token')
    end

    it 'routes to #auth0' do
      expect(get: '/v1/auth/auth0/callback').to route_to('v1/authentication#auth0')
    end
  end
end
