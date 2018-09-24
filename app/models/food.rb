# frozen_string_literal: true

class Food < ApplicationRecord
  has_paper_trail

  belongs_to :box
  belongs_to :unit
  belongs_to :created_user, class_name: 'User'
  belongs_to :updated_user, class_name: 'User'

  validates_presence_of :name
  validates_presence_of :box
  validates_presence_of :unit
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  scope :owned_by, ->(user) { joins(:box).where(boxes: { owner: user }) }
  scope :inviting, ->(user) { joins(box: :invitations).where(box: { invitations: { user: user } }) }
  scope :all_with_invited, ->(user) { owned_by(user) + inviting(user) }

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
             notice: previous.notice,
             amount: previous.amount,
             expiration_date: previous.expiration_date)
    end
    previous
  end
end
