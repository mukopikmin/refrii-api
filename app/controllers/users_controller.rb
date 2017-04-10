class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authenticate_user, only: [:index, :show, :update, :destroy]

  # GET /users
  def index
    @users = User.where(removed: false)
    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # GET /users/search
  def search
    email = params[:email]
    @user = User.find_by_email(email)
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.removed = true
    @user.save
  end

  def verify
    render json: current_user, include: []
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
end
