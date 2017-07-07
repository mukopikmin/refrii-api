class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :provider, :avatar, :created_at, :updated_at

  has_many :boxes
  has_many :units
  has_many :invitations

  def avatar
    if object.has_avatar?
      "#{ENV['HOSTNAME']}/users/#{object.id}/avatar"
    else
      nil
    end
  end
end
