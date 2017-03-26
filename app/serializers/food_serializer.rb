class FoodSerializer < ActiveModel::Serializer
  attributes :id, :name, :amount, :unit, :expiration_date, :created_at, :updated_at

  belongs_to :room
  belongs_to :unit

  def unit
    object.unit.label
  end
end
