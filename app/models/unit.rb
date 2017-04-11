class Unit < ApplicationRecord
  belongs_to :user
  has_many :foods

  scope :owned_by, -> (user) { where(user: user) }

  def is_owned_by(user)
    user.units.include?(self)
  end
end
