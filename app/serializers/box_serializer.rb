class BoxSerializer < ActiveModel::Serializer
  attributes :id, :name, :notice, :created_at, :updated_at

  belongs_to :owner, class_name: User, foreign_key: 'owner_id'
  has_many :rooms
end
