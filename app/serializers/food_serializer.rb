class FoodSerializer < ActiveModel::Serializer
  attributes :id, :name, :notice, :amount, :expiration_date, :image_url,  :created_at, :updated_at

  belongs_to :box
  belongs_to :unit
  belongs_to :created_user
  belongs_to :updated_user

  def image_url
    if object.has_image?
      "#{ENV['HOSTNAME']}/foods/#{object.id}/image"
    else
      nil
    end
  end
end
