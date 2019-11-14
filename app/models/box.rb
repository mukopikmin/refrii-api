# frozen_string_literal: true

class Box < ApplicationRecord
  has_paper_trail

  belongs_to :owner, class_name: 'User'
  has_many :foods
  has_many :invitations
  has_one_attached :image

  validates_presence_of :name
  validates_presence_of :owner
  validates_presence_of :owner

  scope :owned_by, ->(user) { where(owner: user) }
  scope :inviting, ->(user) { joins(:invitations).where(invitations: { user: user }) }
  scope :all_with_invited, lambda { |user|
    scope = includes(:invitations)

    scope.where(owner: user)
         .or(scope.where(invitations: { user: user }))
  }

  def owned_by?(user)
    user.boxes.include?(self)
  end

  def inviting?(user)
    invitations.map(&:user).include?(user)
  end

  def accessible_for?(user)
    owned_by?(user) || inviting?(user)
  end

  def revert
    previous = paper_trail.previous_version

    !previous.nil? && update(
      name: previous.name,
      notice: previous.notice
    )
  end
end
