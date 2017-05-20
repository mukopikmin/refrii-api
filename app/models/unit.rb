class Unit < ApplicationRecord
  validates :label, presence: true
  validates :step, numericality: { greater_than: 0 }
  validates :user, presence: true

  belongs_to :user
  has_many :foods

  scope :owned_by, -> (user) { where(user: user) }

  def is_owned_by(user)
    user.units.include?(self)
  end
end
