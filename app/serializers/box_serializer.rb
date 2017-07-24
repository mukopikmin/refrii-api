class BoxSerializer < ActiveModel::Serializer
  attributes :id, :name, :notice, :image_url, :created_at, :updated_at, :is_invited, :invited_users

  belongs_to :owner
  has_many :foods

  def is_invited
    current_user != object.owner
  end

  def invited_users
    object.invitations.map(&:user)
  end

  def image_url
    "#{ENV['HOSTNAME']}/boxes/#{object.id}/image" if object.has_image?
  end
end
