class User < ApplicationRecord
  has_secure_password

  has_many :boxes
  has_many :units
  has_many :invitations

  def invited_boxes
    self.invitations.map do |invitation|
      invitation.box
    end
  end
end
