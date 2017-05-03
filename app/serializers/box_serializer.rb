class BoxSerializer < ActiveModel::Serializer
  attributes :id, :name, :notice, :created_at, :updated_at

  belongs_to :user
  has_many :foods
  has_many :invitations
end
