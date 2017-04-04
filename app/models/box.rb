class Box < ApplicationRecord
  belongs_to :owner, class_name: User, foreign_key: 'owner_id'
  has_many :foods
  has_many :invitations

  scope :available, -> { where(removed: false )}
  scope :owned_by, -> (user) { where(owner: user) }
  scope :inviting, -> (user) { joins(:invitations).where(invitations: { user: user }) }

  def is_owned_by(user)
    user.boxes.include?(self) || user.invited_boxes.include?(self)
  end

  def self.all_with_invited(user)
    # TODO: should be single query
    self.available.owned_by(user) + self.available.inviting(user)
  end
end
