class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :provider, :avatar_url#, :created_at, :updated_at

  has_many :boxes
  has_many :units
  has_many :invitations

  def avatar_url
    "#{ENV['HOSTNAME']}/users/#{object.id}/avatar" if object.has_avatar?
  end
end
