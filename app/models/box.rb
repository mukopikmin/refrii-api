class Box < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :foods
  has_many :invitations

  validates_presence_of :name
  validates_presence_of :owner

  scope :owned_by, ->(user) { where(owner: user) }
  scope :inviting, ->(user) { joins(:invitations).where(invitations: { user: user }) }
  scope :all_with_invited, ->(user) { owned_by(user) + inviting(user) }

  def is_owned_by(user)
    user.boxes.include?(self)
  end

  def is_inviting(user)
    invitations.map(&:user).include?(user)
  end

  def is_accessible_for(user)
    is_owned_by(user) || is_inviting(user)
  end

  def has_image?
    !(image_file.nil? || image_size.nil? || image_content_type.nil?)
  end
end
