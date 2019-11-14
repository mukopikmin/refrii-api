# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Boxes::VersionsController, type: :controller do
  pending "add some examples to (or delete) #{__FILE__}"

  describe 'GET #index' do
  end

  describe 'POST #create' do
    # let!(:user) { create(:user) }
    # let!(:box) { create(:box, name: name_before, owner: user) }
    # let(:name_before) { 'before changed' }
    # let(:name_after) { 'after changed' }

    # before do
    #   request.headers['Authorization'] = "Bearer #{token(user)}"
    #   put :update, params: { id: box.to_param, name: name_after }
    # end

    # it 'revert the requested box' do
    #   post :create, params: { id: box.to_param }
    #   box.reload
    #   expect(box.name).to eq(name_before)
    # end

    # it 'assigns the reverted box as @box' do
    #   post :create, params: { id: box.to_param }
    #   expect(assigns(:box)).to eq(box)
    # end
  end
end
