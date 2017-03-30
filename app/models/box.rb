class Box < ApplicationRecord
  belongs_to :owner, class_name: User, foreign_key: 'owner_id'
  has_many :foods

  def is_owned_by(user)
    user.boxes.include?(self)
  end
end
