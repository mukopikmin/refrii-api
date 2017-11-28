require 'rails_helper'

RSpec.describe "Units", type: :request do
  def token(user)
    JsonWebToken.payload(user)[:jwt]
  end

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:unit1) { create(:unit, user: user1) }
  let(:unit2) { create(:unit, user: user2) }

  describe 'GET /units' do
    context 'without authentication' do
      before(:each) { get units_path }

      it "returns 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      before(:each) do
        get units_path, headers: { authorization: "Bearer #{token(user1)}" }
      end

      it "returns 200" do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /units/:id' do
    context 'without authentication' do
      before(:each) { get unit_path(unit1) }

      it "returns 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own unit' do
        before(:each) do
          get unit_path(unit1), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it "returns 200" do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with other\'s unit' do
        before(:each) do
          get unit_path(unit2), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it "returns 404" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'POST /units' do
    context 'without authentication' do
      let(:params) { attributes_for(:unit).merge!(unit_id: unit1.to_param) }
      before(:each) { post units_path, params: params }

      it "returns 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with valid params' do
        let(:params) { attributes_for(:unit) }

        before(:each) do
          post units_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it "returns 201" do
          expect(response).to have_http_status(:created)
        end
      end

      context 'with no label unit' do
        let(:params) { attributes_for(:no_label_unit) }

        before(:each) do
          post units_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it "returns 400" do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with existing label unit' do
        let(:params) { attributes_for(:unit).merge!(user_id: user1.id) }
        let!(:unit) { Unit.create(params) }

        before(:each) do
          post units_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it "returns 400" do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe 'PUT /units/:id' do
    context 'without authentication' do
      let(:params) { attributes_for(:unit) }

      before(:each) { put unit_path(unit1), params: params }

      it "returns 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own unit' do
        let(:params) { attributes_for(:unit) }

        before(:each) do
          put unit_path(unit1), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it "returns 200" do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with other\'s unit' do
        let(:params) { attributes_for(:unit) }

        before(:each) do
          put unit_path(unit2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it "returns 400" do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with no label unit' do
        let(:params) { attributes_for(:no_label_unit) }

        before(:each) do
          put unit_path(unit2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it "returns 400" do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with existing label unit' do
        let(:params) { attributes_for(:unit).merge!(user_id: user1.id) }
        let!(:unit) { Unit.create(params) }

        before(:each) do
          put unit_path(unit1), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it "returns 400" do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'without renaming label of unit' do
        let(:params) { attributes_for(:unit).merge!(user_id: user1.id) }

        before(:each) do
          put unit_path(unit1), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it "returns 200" do
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe 'DELETE /units/:id' do
    context 'without authentication' do
      before(:each) { delete unit_path(unit1) }

      it "returns 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own unit' do
        context 'with unit not referenced by foods' do
          before(:each) do
            delete unit_path(unit1), headers: { authorization: "Bearer #{token(user1)}" }
          end

          it "returns 201" do
            expect(response).to have_http_status(:no_content)
          end
        end

        context 'with unit referenced by foods' do
          let(:box) { create(:box, owner: user1) }
          let!(:food) { create(:food, box: box, unit: unit1, created_user: user1, updated_user: user1) }

          before(:each) do
            delete unit_path(unit1), headers: { authorization: "Bearer #{token(user1)}" }
          end

          it "returns 400" do
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      context 'with other\'s unit' do
        before(:each) do
          delete unit_path(unit2), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it "returns 400" do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end
