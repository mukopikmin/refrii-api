# frozen_string_literal: true

class V1::UsersController < V1::ApplicationController
  before_action :set_user, only: %i[show avatar update destroy push_token]
  before_action :authenticate_request!, only: %i[index verify show search update push_token]

  # GET /users
  def index
    if current_user.admin
      @users = User.all
      render json: @users
    else
      forbidden('Only administrator of this service is allowed.')
    end
  end

  # GET /users/verify
  def verify
    @user = current_user
    if @user.nil?
      not_found
    else
      render json: @user
    end
  end

  # GET /users/1
  def show
    if !accessible?
      forbidden('Access not allowed.')
    else
      render json: @user
    end
  end

  # GET /users/search
  def search
    email = params[:email]
    @user = User.find_by_email(email)

    if @user.nil?
      not_found("Uesr #{email} does not exist.")
    else
      render json: @user
    end
  end

  # POST /users
  # def create
  #   @user = User.new(user_params)

  #   if @user.save
  #     render json: @user, status: :created
  #   else
  #     bad_request
  #   end
  # end

  # POST /users/google
  def create_with_google
    params = google_signup_params

    if User.where(email: params[:email]).exists?
      bad_request('Specidied email address is already in use.')
    elsif (@user = User.register_from_google(params)).persisted?
      render json: @user, status: :created
    else
      bad_request
    end
  end

  # PATCH/PUT /users/1
  def update
    if !accessible?
      forbidden('You can only update self.')
    elsif @user.update(user_params)
      @user.avatar.attach(attachment_param(params[:avatar])) if avatar_in_params?

      render json: @user
    else
      bad_request
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:name)
  end

  def avatar_in_params?
    !params[:avatar].nil?
  end

  def google_signup_params
    token = request.headers['Authorization']
    http_token = token.split(' ').last if token.present?
    auth_token = FirebaseUtils::Auth.verify_id_token(http_token)
    payload = auth_token['decoded_token'][:payload]

    {
      email: payload['email'],
      name: payload['name'],
      avatar_url: payload['picture']
    }
  end

  def push_token_params
    params[:user_id] = current_user.id

    params.permit(:user_id, :token)
  end

  def accessible?
    @user.id == current_user.id
  end
end
