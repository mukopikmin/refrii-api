# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Boxes', type: :request do
  include Committee::Test::Methods
  include Rack::Test::Methods

    def token(user)
    JsonWebToken.payload(user)[:jwt]
  end

  def committee_schema
    @committee_schema ||=
      begin
        driver = Committee::Drivers::OpenAPI2.new
        schema = JSON.parse(File.read(schema_path))
        driver.parse(schema)
      end
  end

  def schema_path
    Rails.root.join('docs/swagger.json')
  end

  def committee_options
    @committee_options ||= { validate_errors: true}
  end

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:box1) { create(:box, owner: user1) }
  let!(:box2) { create(:box, owner: user2) }
  let!(:box3) { create(:box, owner: user2) }

  before { Invitation.create(box: box3, user: user1) }

  describe 'GET /boxes' do
    context 'without authentication' do
      before {get v1_boxes_path}
      subject {last_response.status}

      it { is_expected.to eq(401)}
    end

    context 'with authentication' do
      it 'conforms schema' do
        header "authorization", "Bearer #{token(user1)}" 
        get v1_boxes_path

        assert_schema_conform
      end
    end
  end

  describe 'GET /boxes/owns' do
    context 'without authentication' do
      before { get owns_v1_boxes_path }
      subject {last_response.status}

      it { is_expected.to eq(401)}
    end

    context 'with authentication' do
      it 'conforms schema' do
        header "authorization", "Bearer #{token(user1)}" 
        get owns_v1_boxes_path

        assert_schema_conform
      end
    end
  end

  describe 'GET /boxes/invited' do
    context 'without authentication' do
      before { get invited_v1_boxes_path }
      subject {last_response.status}

      it { is_expected.to eq(401)}
    end

    context 'with authentication' do
      it 'returns 200' do
        header "authorization", "Bearer #{token(user1)}" 
        get invited_v1_boxes_path
        
        assert_schema_conform
      end
    end
  end

  describe 'GET /boxes/:id' do
    context 'without authentication' do
      before { get v1_box_path(box1) }
      subject {last_response.status}

      it { is_expected.to eq(401)}
    end

    context 'with authentication' do
      context 'with own box' do
        it 'returns 200' do
        header "authorization", "Bearer #{token(user1)}" 
        get v1_box_path(box1)

          assert_schema_conform
        end
      end

      context 'with other\'s box' do
          before do
        header "authorization", "Bearer #{token(user1)}" 
        get v1_box_path(box2) 
          end
          subject {last_response.status}
    
          it { is_expected.to eq(404)}
      end
    end
  end

  describe 'GET /boxes/:id/versions' do
    context 'without authentication' do
      before { get versions_v1_box_path(box1) }
      subject {last_response.status}

      it { is_expected.to eq(401)}
    end

    context 'with authentication' do
      it 'returns 200' do
        header "authorization", "Bearer #{token(user1)}" 
        get versions_v1_box_path(box1)

        assert_schema_conform
      end
    end
  end

  describe 'GET /boxes/:id/image' do
    let(:user) { create(:user) }
    let(:box) { create(:box, :with_image, owner: user) }
    let(:no_image_box) { create(:box, owner: user) }

    context 'without authentication' do
      before { get image_v1_box_path(box) }
      subject {last_response.status}

      it { is_expected.to eq(401)}
    end

    context 'with authentication' do
      context 'with image' do
        before do
          header "authorization", "Bearer #{token(user)}" 
          get image_v1_box_path(box)
        end
        subject {last_response.status}
  
        it { is_expected.to eq(200)}
      end

      context 'with no image' do
        before do
          header "authorization", "Bearer #{token(user)}" 
          get image_v1_box_path(no_image_box)
        end
        subject {last_response.status}
  
        it { is_expected.to eq(404)}
      end

      context 'with base64 requested param' do
        before do
          header "authorization", "Bearer #{token(user)}" 
          get image_v1_box_path(box), params: { base64: true }
        end
        subject {last_response.status}
  
        it { is_expected.to eq(200)}
      end
    end
  end

  describe 'GET /boxes/:id/units' do
    context 'without authentication' do
      before { get units_v1_box_path(box1) }
      subject {last_response.status}

      it { is_expected.to eq(401)}
    end

    context 'with authentication' do
      context 'with own box' do
        it 'returns 200' do
        header "authorization", "Bearer #{token(user1)}" 
        get units_v1_box_path(box1)
        
          assert_schema_conform
        end
      end

      context 'with other\'s box' do
        before do
        header "authorization", "Bearer #{token(user1)}" 
        get units_v1_box_path(box2)
        end
        subject {last_response.status}

        it { is_expected.to eq(404)}
      end
    end
  end

  describe 'POST /boxes' do
    let(:params) { attributes_for(:box) }
    let(:no_name_box) { attributes_for(:no_name_box) }

    context 'without authentication' do
      before { post v1_boxes_path, params: params }
      subject {last_response.status}

      it { is_expected.to eq(401)}
    end

    context 'with authentication' do
      it 'returns 201' do
        header "authorization", "Bearer #{token(user1)}" 
        post v1_boxes_path, params

        assert_schema_conform
      end
    end

    context 'with no name params' do
      before do
        header "authorization", "Bearer #{token(user1)}" 
        post v1_boxes_path, params: no_name_box
      end
      subject {last_response.status}

      it { is_expected.to eq(400)}
    end
  end

  describe 'PUT /boxes/:id' do
    let(:params) { attributes_for(:box) }
    let(:no_name_box) { attributes_for(:no_name_box) }

    context 'without authentication' do
      before { put v1_box_path(box1), params: params }
      subject {last_response.status}

      it { is_expected.to eq(401)}
    end

    context 'with authentication' do
      context 'with own box' do
        it 'returns 200' do
        header "authorization", "Bearer #{token(user1)}" 
        put v1_box_path(box1)
        
          assert_schema_conform
        end
      end

      context 'with other\'s box' do
        before do
        header "authorization", "Bearer #{token(user1)}" 
        put v1_box_path(box2), params: params
        end
        subject {last_response.status}

        it { is_expected.to eq(400)}
      end

      context 'with no name params' do

        it 'returns 200' do
        header "authorization", "Bearer #{token(user1)}" 
        put v1_box_path(box1), params: no_name_box

          assert_schema_conform
        end
      end
    end
  end

  describe 'DELETE /boxes/:id' do
    context 'without authentication' do
      before { delete v1_box_path(box1) }
      subject {last_response.status}

      it { is_expected.to eq(401)}
    end

    context 'with authentication' do
      context 'with own box' do
        it 'returns 204' do
        header "authorization", "Bearer #{token(user1)}" 
        delete v1_box_path(box1)
        
          assert_schema_conform
        end
      end

      context 'with other\'s box' do
        before do
        header "authorization", "Bearer #{token(user1)}" 
        delete v1_box_path(box2)
        end
        subject {last_response.status}

        it { is_expected.to eq(400)}
      end

      context 'with invited box' do
        before do
        header "authorization", "Bearer #{token(user1)}" 
        delete v1_box_path(box3)
        end
        subject {last_response.status}

        it { is_expected.to eq(400)}
      end
    end
  end

  describe 'POST /boxes/:id/invite' do
    let(:params) { { email: user2.email } }
    let(:unpersisted_user) { attributes_for(:user) }

    context 'without authentication' do
      before { post invite_v1_box_path(box1), params: params }
      subject {last_response.status}

      it { is_expected.to eq(401)}
    end

    context 'with authentication' do
      context 'with own box' do
        it 'returns 201' do
        header "authorization", "Bearer #{token(user1)}" 
        post invite_v1_box_path(box1), params

        assert_schema_conform
        end
      end

      context 'with other\'s box' do
        before do
          header "authorization", "Bearer #{token(user1)}" 
          post invite_v1_box_path(box2), params: params
        end
        subject {last_response.status}

        it { is_expected.to eq(400)}
      end

      context 'with unpersisted user' do
        before do
          header "authorization", "Bearer #{token(user1)}" 
          post invite_v1_box_path(box1), params: unpersisted_user
        end
        subject {last_response.status}

        it { is_expected.to eq(400)}
      end
    end
  end

  describe 'DELETE /boxes/:id/invite' do
    let(:params) { { user_id: user2.to_param } }
    let(:unpersisted_user) { attributes_for(:user) }

    context 'without authentication' do
      before { delete invite_v1_box_path(box3), params: params }
      subject {last_response.status}

      it { is_expected.to eq(401)}
    end

    context 'with authentication' do
      context 'with own box' do
        it 'returns 204' do
          header "authorization", "Bearer #{token(user1)}" 
          delete invite_v1_box_path(box3), params: params
          
          assert_schema_conform
        end
      end

      context 'with other\'s box' do
        before do
          header "authorization", "Bearer #{token(user1)}" 
          delete invite_v1_box_path(box2), params: params
        end
        subject {last_response.status}

        it { is_expected.to eq(400)}
      end

      context 'with unpersisted user' do
        before do
          header "authorization", "Bearer #{token(user1)}" 
          delete invite_v1_box_path(box1), params: unpersisted_user
        end
        subject {last_response.status}

        it { is_expected.to eq(400)}
      end
    end
  end
end
