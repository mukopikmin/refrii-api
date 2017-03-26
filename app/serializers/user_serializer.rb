class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :created_at, :updated_at

  has_many :boxes
  has_many :units
end
