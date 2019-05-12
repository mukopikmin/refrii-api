# frozen_string_literal: true

class FoodSerializer < ApplicationRecordSerializer
  attributes :id,
             :name,
             :notice,
             :amount,
             :expiration_date,
             :image_url,
             :needs_adding,
             :created_at,
             :updated_at

  belongs_to :box
  belongs_to :unit
  belongs_to :created_user
  belongs_to :updated_user

  def image_url
    object.image.attached? ? url_for(object.image) : nil
  end
end
