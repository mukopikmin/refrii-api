class Box < ApplicationRecord
  belongs_to :owner, class_name: User, foreign_key: 'owner_id'
  has_many :foods
  has_many :invitations

  scope :owned_by, -> (user) { where(owner: user) }
  scope :inviting, -> (user) { joins(:invitations).where(invitations: { user: user }) }

  def is_owned_by(user)
    user.boxes.include?(self) || user.invited_boxes.include?(self)
  end

  def self.all_with_invited(user)
    # TODO: should be single query
    self.owned_by(user) + self.inviting(user)
  end
end
