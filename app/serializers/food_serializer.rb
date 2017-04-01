class FoodSerializer < ActiveModel::Serializer
  attributes :id, :name, :notice, :amount, :unit_label, :expiration_date, :created_at, :updated_at

  belongs_to :box
  belongs_to :unit

  def unit_label
    object.unit.label
  end
end
