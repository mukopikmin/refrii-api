class Food < ApplicationRecord
  belongs_to :box
  belongs_to :unit

  scope :owned_by, ->(user) { joins(:box).where(boxes: { owner: user }) }
  scope :inviting, ->(user) { joins(box: :invitations).where(box: { invitations: { user: user } }) }
  scope :all_with_invited, -> (user) { owned_by(user) + inviting(user) }
end
