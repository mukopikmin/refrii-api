# frozen_string_literal: true

class User < ApplicationRecord
  has_many :boxes, class_name: 'Box', foreign_key: 'owner_id'
  has_many :units
  has_many :invitations
  has_many :push_tokens
  has_many :created_foods, class_name: 'Food', foreign_key: 'created_user_id'
  has_many :updated_foods, class_name: 'Food', foreign_key: 'updated_user_id'
  has_one_attached :avatar

  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :provider
  validates :email, presence: true,
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates_uniqueness_of :email, on: :create, scope: :provider
  validates_inclusion_of :disabled, in: [true, false]
  validates_inclusion_of :admin, in: [true, false]

  def local_user?
    provider == 'local'
  end

  def invited_boxes
    invitations.map(&:box)
  end

  def unit_owns?(label)
    units.map(&:label).include?(label)
  end

  def self.register_from_google(name: nil, email: nil, avatar_url: nil)
    Tempfile.open do |tempfile|
      user = User.create(name: name,
                         email: email,
                         provider: 'google')

      unless avatar_url.nil?
        response = RestClient.get(avatar_url)
        image = response.body
        content_type = response.headers[:content_type]

        tempfile.binmode
        tempfile.write(image)
        user.avatar.attach(io: tempfile.open,
                           filename: File.basename(tempfile.path),
                           content_type: content_type)
      end

      user
    end
  end
end
