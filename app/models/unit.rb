class Unit < ApplicationRecord
  belongs_to :user
  has_many :foods

  def is_owned_by(user)
    user.units.include?(self)
  end
end
