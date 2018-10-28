# frozen_string_literal: true

class Box < ApplicationRecord
  has_paper_trail

  belongs_to :owner, class_name: 'User'
  has_many :foods
  has_many :invitations

  validates_presence_of :name
  validates_presence_of :owner

  scope :owned_by, ->(user) { where(owner: user) }
  scope :inviting, ->(user) { joins(:invitations).where(invitations: { user: user }) }
  scope :all_with_invited, ->(user) do
    scope = includes(:invitations)

    scope.where(owner: user)
         .or(scope.where(invitations: { user: user }))
  end

  def owned_by?(user)
    user.boxes.include?(self)
  end

  def inviting?(user)
    invitations.map(&:user).include?(user)
  end

  def accessible_for?(user)
    owned_by?(user) || inviting?(user)
  end

  def image_exists?
    !(image_file.nil? || image_size.nil? || image_content_type.nil?)
  end

  def base64_image
    return nil unless image_exists?

    {
      content_type: image_content_type,
      size: image_size,
      base64: Base64.strict_encode64(image_file)
    }
  end

  def revert
    previous = paper_trail.previous_version
    unless previous.nil?
      update(name: previous.name,
             notice: previous.notice)
    end
    previous
  end
end
