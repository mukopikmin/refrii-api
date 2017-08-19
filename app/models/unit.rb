class Unit < ApplicationRecord
  validates_presence_of :label
  validates :step, presence: true,
                   numericality: { greater_than: 0 }
  validates_presence_of :user
  validates_uniqueness_of :label, scope: :user

  belongs_to :user
  has_many :foods

  scope :owned_by, ->(user) { where(user: user) }

  def is_owned_by(user)
    user.units.include?(self)
  end
end
