class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authenticate_request!, only: [:index, :verify, :show, :search, :update]

  # GET /users
  # def index
  #   @users = User.all
  #   render json: @users
  # end

  # GET /users/verify
  def verify
    @user = current_user
    if @user.nil?
      not_found
    else
      render json: @user, include: []
    end
  end

  # GET /users/1
  # def show
  #   render json: @user
  # end

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
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      bad_request
    end
  end

  # PATCH/PUT /users/1
  def update
    if !updatable?
      forbidden('You can only update self.')
    elsif @user.update(user_params)
      render json: @user
    else
      bad_request
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def updatable?
    @user.id == current_user.id
  end
end
