# frozen_string_literal: true

class V1::BoxesController < V1::ApplicationController
  before_action :authenticate_request!
  before_action :set_paper_trail_whodunnit
  before_action :set_box, only: %i[show update destroy]

  # GET /boxes
  def index
    case filter_option
    when :all
      render json: Box.all_with_invited(current_user)
    when :owns
      render json: Box.owned_by(current_user)
    when :invited
      render json: Box.inviting(current_user)
    else
      bad_request('Unknown option is specified')
    end
  end

  # GET /boxes/1
  def show
    if !accessible?
      not_found('Specified box does not exist.')
    else
      render json: @box
    end
  end

  # POST /boxes
  def create
    @box = Box.new(box_params)

    if @box.save
      render json: @box, status: :created
    else
      bad_request
    end
  end

  # PATCH/PUT /boxes/1
  def update
    if !owner_of_box?
      forbidden('You can not update the box.')
    elsif @box.update(box_params)
      render json: @box
    else
      bad_request
    end
  end

  # DELETE /boxes/1
  def destroy
    if !owner_of_box?
      forbidden('You can not destroy the box.')
    else
      @box.destroy
    end
  end

  private

  def set_box
    @box = Box.find(params[:id])
  end

  def box_params
    params[:owner_id] = current_user.id

    params.permit(:name,
                  :notice,
                  :owner_id)
  end

  def accessible?
    @box.accessible_for?(current_user)
  end

  def owner_of_box?
    @box.owned_by?(current_user)
  end

  def filter_option
    option = params['filter']

    case option
    when nil
      :all
    when 'owns', 'invited'
      option.to_sym
    end
  end
end
