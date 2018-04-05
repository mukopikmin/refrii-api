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

  scope :owned_by, -> (user) { joins(:box).where(boxes: { owner: user }) }
  scope :inviting, -> (user) { joins(box: :invitations).where(box: { invitations: { user: user } }) }
  scope :all_with_invited, -> (user) { owned_by(user) + inviting(user) }

  def has_image?
    !(image_file.nil? || image_size.nil? || image_content_type.nil?)
  end

  def base64_image
    if has_image?
      {
        content_type: image_content_type,
        size: image_size,
        base64: Base64.strict_encode64(image_file)
      }
    else
      nil
    end
  end
end
