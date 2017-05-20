class BoxSerializer < ActiveModel::Serializer
  attributes :id, :name, :notice, :created_at, :updated_at, :is_invited

  belongs_to :user
  has_many :foods
  has_many :invitations

  def is_invited
    current_user != object.user
  end
end
