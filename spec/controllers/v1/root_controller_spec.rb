# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::RootController, type: :controller do
  describe 'GET #index' do
    it 'returns some json' do
      get :index
      expect(assigns(:content)).to be_a(Hash)
    end
  end
end
