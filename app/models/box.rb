class Box < ApplicationRecord
  belongs_to :user
  has_many :foods
  has_many :invitations

  scope :owned_by, -> (user) { where(user: user) }
  scope :inviting, -> (user) { joins(:invitations).where(invitations: { user: user }) }
  scope :all_with_invited, -> (user) { owned_by(user) + inviting(user) }

  def is_owned_by(user)
    user.boxes.include?(self) || user.invited_boxes.include?(self)
  end

  def is_inviting(user)
    self.invitations.map(&:user).include?(user)
  end

  def is_accesable(user)
    self.is_owned_by(user) || self.is_inviting(user)
  end
end
