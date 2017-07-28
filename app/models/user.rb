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
    provider = 'google'
    user = nil
    if exists?(email: email, provider: provider)
      user = where(email: email, provider: provider).first
    else
      avatar = download_image(auth[:info][:image])
      user = new(name: auth[:info][:name],
                 email: email,
                 password_digest: 'no password',
                 provider: provider,
                 avatar_file: avatar[:file],
                 avatar_size: avatar[:size],
                 avatar_content_type: avatar[:content_type])
      user.save!
    end
    user
  end

  def self.find_for_auth0(auth)
    email = auth[:info][:email]
    provider = "auth0/#{auth[:extra][:raw_info][:identities].first[:provider]}"
    user = nil
    if exists?(email: email, provider: provider)
      user = where(email: email, provider: provider).first
    else
      avatar = download_image(auth[:info][:image])
      user = new(name: auth[:info][:name],
                 email: email,
                 password_digest: 'no password',
                 provider: provider,
                 avatar_file: avatar[:file],
                 avatar_size: avatar[:size],
                 avatar_content_type: avatar[:content_type])
      user.save!
    end
    user
  end

  private

  def self.download_image(url)
    open(url) do |io|
      Tempfile.open do |tempfile|
        tempfile.binmode
        tempfile.write(io.read)
        {
          file: tempfile.open.read,
          size: tempfile.size,
          content_type: io.content_type
        }
      end
    end
  end

  # def self.avatar_valid?(params)
  #   params[:file] && params[:size] && params[:content_type]
  # end
end
