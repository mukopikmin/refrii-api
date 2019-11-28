# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Users::PushTokensController', type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/v1/users/1/push_tokens').to route_to('v1/users/push_tokens#create', user_id: '1')
    end
  end
end
