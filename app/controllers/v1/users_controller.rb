# frozen_string_literal: true

module V1
  class UsersController < V1::ApplicationController
    before_action :set_user, only: %i[show avatar update destroy push_token]
    before_action :authenticate_request!, only: %i[index avatar verify show search update]

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
        render json: @user, include: []
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

    # GET /users/1/avatar
    def avatar
      if @user.avatar_exists? && accessible?
        if requested_base64?
          render json: @user.base64_avatar
        else
          send_data @user.avatar_file, type: @user.avatar_content_type, disposition: 'inline'
        end
      else
        not_found('Avatar does not exist.')
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
    def create
      @user = User.new(user_params)

      if @user.save
        render json: @user, status: :created, location: v1_users_path(@user)
      else
        bad_request
      end
    end

    # PATCH/PUT /users/1
    def update
      if !accessible?
        forbidden('You can only update self.')
      elsif @user.update(user_params)
        render json: @user
      else
        bad_request
      end
    end

    # POST /users/1/push_token
    def push_token
      @push_token = PushToken.new(push_token_params)

      if !accessible?
        forbidden('You can only update self.')
      elsif @push_token.save
        render json: current_user
      else
        bad_request
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      avatar = params[:avatar]

      if avatar_attached?(avatar)
        original = Magick::Image.from_blob(avatar.read).first
        params[:avatar_file] = original.resize_to_fit(Settings.rmagick.width, Settings.rmagick.height).to_blob
        params[:avatar_size] = params[:avatar_file].size
        params[:avatar_content_type] = avatar.content_type
      end

      params.permit(:name,
                    :email,
                    :password,
                    :password_confirmation,
                    :avatar_file,
                    :avatar_size,
                    :avatar_content_type)
    end

    def push_token_params
      params[:user_id] = current_user.id

      params.permit(:user_id, :token)
    end

    def accessible?
      @user.id == current_user.id
    end

    def requested_base64?
      params[:base64] == 'true'
    end

    def avatar_attached?(param)
      !(param == 'null' || param == '' || param.nil?)
    end
  end
end
