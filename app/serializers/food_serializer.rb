class FoodSerializer < ActiveModel::Serializer
  attributes :id, :name, :notice, :amount, :expiration_date, :created_at, :updated_at

  belongs_to :box
  belongs_to :unit
  belongs_to :created_user
  belongs_to :updated_user
end
