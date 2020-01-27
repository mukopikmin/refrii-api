# frozen_string_literal: true

class V1::BoxesController < V1::ApplicationController
  before_action :authenticate_request!
  before_action :set_paper_trail_whodunnit
  before_action :set_box, only: %i[show update destroy]

  # GET /boxes
  def index
    # current_user=User.all.first

    case filter_option
    when :all
      @boxes = Box.all_with_invited(current_user)
    when :owns
      @boxes = Box.owned_by(current_user)
    when :invited
      @boxes = Box.inviting(current_user)
    end

    render json: @boxes
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
      render json: @box, status: :created, location: v1_boxes_path(@box)
    else
      bad_request
    end
  end

  # PATCH/PUT /boxes/1
  def update
    if !owner_of_box?
      bad_request('You can not update the box.')
    elsif @box.update(box_params)
      render json: @box
    else
      bad_request
    end
  end

  # DELETE /boxes/1
  def destroy
    if !owner_of_box?
      bad_request('You can not destroy the box.')
    else
      @box.destroy
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_box
    @box = Box.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
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
    when 'owns', 'invited'
      option.to_sym
    else
      :all
    end
  end
end
