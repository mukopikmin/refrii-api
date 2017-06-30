class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, length: { minimum: 1 }
  validates :email, presence: true, length: { minimum: 1 }
  validates :password_confirmation, presence: true, if: :local_user?
  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  has_many :boxes
  has_many :units
  has_many :invitations
  has_many :created_foods, class_name: 'Food', foreign_key: 'created_user_id'
  has_many :updated_foods, class_name: 'Food', foreign_key: 'updated_user_id'

  def valid_password?(unencrypted_password)
    BCrypt::Password.new(password_digest) == unencrypted_password && self
  end

  def local_user?
    provider == 'local'
  end

  def invited_boxes
    invitations.map(&:box)
  end

  def has_unit_labeled_with(label)
    units.map(&:label).include?(label)
  end

  def self.find_for_database_authentication(conditions)
    where(conditions).first
  end

  def self.find_for_google(auth)
    email = auth[:info][:email]
    user = nil
    if exists?(email: email)
      user = where(email: email).first
    else
      user = new(name: auth[:info][:name],
                 email: email,
                 password_digest: 'no password',
                 provider: 'google')
      user.save!
    end
    user
  end
end
