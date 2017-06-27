class Food < ApplicationRecord
  validates :name, length: { minimum: 1 }
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :box, presence: true
  validates :unit, presence: true

  belongs_to :box
  belongs_to :unit

  scope :owned_by, -> (user) { joins(:box).where(boxes: { user: user }) }
  scope :inviting, -> (user) { joins(box: :invitations).where(box: { invitations: { user: user } }) }
  scope :all_with_invited, -> (user) { owned_by(user) + inviting(user) }
end
