# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :boxes, class_name: 'Box', foreign_key: 'owner_id'
  has_many :units
  has_many :invitations
  has_many :push_tokens
  has_many :created_foods, class_name: 'Food', foreign_key: 'created_user_id'
  has_many :updated_foods, class_name: 'Food', foreign_key: 'updated_user_id'
  has_one_attached :avatar

  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :password_confirmation, if: :local_user?
  validates :email, presence: true,
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates_uniqueness_of :email, scope: :provider

  def valid_password?(unencrypted_password)
    BCrypt::Password.new(password_digest) == unencrypted_password && self
  end

  def local_user?
    provider == 'local'
  end

  def avatar_exists?
    !(avatar_file.nil? || avatar_size.nil? || avatar_content_type.nil?)
  end

  def invited_boxes
    invitations.map(&:box)
  end

  def unit_owns?(label)
    units.map(&:label).include?(label)
  end

  def base64_avatar
    return nil unless avatar_exists?

    {
      content_type: avatar_content_type,
      size: avatar_size,
      base64: Base64.strict_encode64(avatar_file)
    }
  end

  def self.download_image(url)
    Tempfile.open do |tempfile|
      response = RestClient.get(url)
      image = response.body
      content_type = response.headers[:content_type]

      tempfile.binmode
      tempfile.write(image)

      {
        file: tempfile.open.read,
        size: tempfile.size,
        content_type: content_type
      }
    end
  end
end
