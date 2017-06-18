class User < ApplicationRecord
  has_secure_password

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  has_many :boxes
  has_many :units
  has_many :invitations

  def valid_password?(unencrypted_password)
    BCrypt::Password.new(password_digest) == unencrypted_password && self
  end

  def invited_boxes
    self.invitations.map do |invitation|
      invitation.box
    end
  end

  def self.find_for_database_authentication(conditions)
    self.where(conditions).first
  end

  def self.find_for_google(auth)
    user = self.new(name: auth[:info][:name],
                    email: auth[:info][:email],
                    password_digest: 'blank',
                    provider: 'google')
    unless self.exists?(email: auth[:info][:email])
      user.save!
    else
      user = self.where(email: auth[:info][:email]).first
    end
    user
  end
end
