class RoomSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at

  belongs_to :box
  has_many :foods
end
