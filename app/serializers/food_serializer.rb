class FoodSerializer < ActiveModel::Serializer
  attributes :id, :name, :notice, :amount, :expiration_date, :image,  :created_at, :updated_at

  belongs_to :box
  belongs_to :unit
  belongs_to :created_user
  belongs_to :updated_user

  def image
    if object.has_image?
      "#{ENV['HOSTNAME']}/foods/#{object.id}/image"
    else
      nil
    end
  end
end
