class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, length: { minimum: 1 }
  validates :email, presence: true, length: { minimum: 1 }
  validates :password_confirmation, presence: true, if: :local_user?
  validates :email,
            presence: true,
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates_uniqueness_of :email, scope: :provider

  has_many :boxes, class_name: 'Box', foreign_key: 'owner_id'
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

  def has_avatar?
    !(avatar_file.nil? || avatar_size.nil? || avatar_content_type.nil?)
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

  def self.find_for_auth0(auth)
    email = auth[:info][:email]
    provider = "auth0/#{auth[:extra][:raw_info][:identities].first[:provider]}"
    user = nil
    if exists?(email: email, provider: provider)
      user = where(email: email, provider: provider)
    else
      user = new(name: auth[:info][:name],
                 email: email,
                 password_digest: 'no password',
                 provider: provider)
      user.save!
    end
    user
  end
end
