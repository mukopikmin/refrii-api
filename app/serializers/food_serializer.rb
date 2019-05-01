# frozen_string_literal: true

class FoodSerializer < ActiveModel::Serializer
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
  belongs_to :shop_plans
  belongs_to :created_user
  belongs_to :updated_user

  def image_url
    "#{ENV['HOSTNAME']}/foods/#{object.id}/image" if object.image_exists?
  end
end
