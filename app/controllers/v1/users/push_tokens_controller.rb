# frozen_string_literal: true

class V1::Users::PushTokensController < V1::ApplicationController
  before_action :authenticate_request!
  before_action :set_user

  # POST /users/1/push_tokens
  def create
    @push_token = PushToken.new(push_token_params)

    if !accessible?
      forbidden('You can only update self.')
    elsif @push_token.exists?
      bad_request('The token already exists.')
    elsif @push_token.save
      render json: @user, status: :created
    else
      bad_request
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def push_token_params
    params[:user_id] = @user.id

    params.permit(:user_id, :token)
  end

  def accessible?
    @user.id == current_user.id
  end
end
