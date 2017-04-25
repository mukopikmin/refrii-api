class Box < ApplicationRecord
  belongs_to :owner, class_name: User, foreign_key: 'owner_id'
  has_many :foods
  has_many :invitations

  scope :owned_by, -> (user) { where(owner: user) }
  scope :inviting, -> (user) { joins(:invitations).where(invitations: { user: user }) }
  scope :all_with_invited, -> (user) { owned_by(user) + inviting(user) }

  def is_owned_by(user)
    user.boxes.include?(self) || user.invited_boxes.include?(self)
  end
end
