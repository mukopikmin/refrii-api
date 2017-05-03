class UnitSerializer < ActiveModel::Serializer
  attributes :id, :label, :step

  # belongs_to :user
  # has_many :foods
end
