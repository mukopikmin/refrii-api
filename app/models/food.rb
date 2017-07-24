class Food < ApplicationRecord
  validates :name, length: { minimum: 1 }
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :box, presence: true
  validates :unit, presence: true

  belongs_to :box
  belongs_to :unit
  belongs_to :created_user, class_name: 'User'
  belongs_to :updated_user, class_name: 'User'

  scope :owned_by, -> (user) { joins(:box).where(boxes: { owner: user }) }
  scope :inviting, -> (user) { joins(box: :invitations).where(box: { invitations: { user: user } }) }
  scope :all_with_invited, -> (user) { owned_by(user) + inviting(user) }

  def has_image?
    !(image_file.nil? || image_size.nil? || image_content_type.nil?)
  end
end
