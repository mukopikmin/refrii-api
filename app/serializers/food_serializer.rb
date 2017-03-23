class FoodSerializer < ActiveModel::Serializer
  attributes :id, :name, :amount, :expiration_date, :created_at, :updated_at

  belongs_to :room
end
