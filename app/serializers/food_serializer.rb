class FoodSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :notice,
             :amount,
             :expiration_date,
             :image_url,
             :needs_adding,
             :created_at,
             :updated_at,
             :changeset

  belongs_to :box
  belongs_to :unit
  belongs_to :created_user
  belongs_to :updated_user

  def image_url
    "#{ENV['HOSTNAME']}/foods/#{object.id}/image" if object.has_image?
  end

  def changeset
    object.versions.map(&:changeset).reverse
  end
end
