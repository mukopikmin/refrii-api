class User < ApplicationRecord
  has_secure_password

  has_many :boxes, class_name: Box, foreign_key: 'owner_id'
  has_many :units
  has_many :invitations

  scope :find_by_email, -> (email) { find_by(email: email) }

  def invited_boxes
    self.invitations.map do |invitation|
      invitation.box
    end
  end
end
