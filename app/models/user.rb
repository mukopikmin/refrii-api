class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  has_many :boxes
  has_many :units
  has_many :invitations

  def invited_boxes
    self.invitations.map do |invitation|
      invitation.box
    end
  end
end
