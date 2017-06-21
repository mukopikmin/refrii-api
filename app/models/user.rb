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
    self.invitations.map(&:box)
  end

  def self.find_for_database_authentication(conditions)
    self.where(conditions).first
  end

  def self.find_for_google(auth)
    email = auth[:info][:email]
    user = nil
    unless self.exists?(email: email)
      user = self.new(name: auth[:info][:name],
                      email: email,
                      password_digest: 'blank',
                      provider: 'google')
      user.save!
    else
      user = self.where(email: email).first
    end
    user
  end
end
