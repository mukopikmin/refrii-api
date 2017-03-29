class UnitSerializer < ActiveModel::Serializer
  attributes :id, :label

  belongs_to :user
  has_many :foods
end
