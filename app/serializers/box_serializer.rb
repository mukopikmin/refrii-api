class BoxSerializer < ActiveModel::Serializer
  attributes :id, :name, :notice, :image_url, :created_at, :updated_at, :is_invited

  belongs_to :user
  has_many :foods
  has_many :invitations

  def is_invited
    current_user != object.user
  end

  def image_url
    if object.has_image?
      "#{ENV['HOSTNAME']}/boxes/#{object.id}/image"
    else
      nil
    end
  end
end
