# frozen_string_literal: true

class BoxSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :notice,
             :image_url,
             :created_at,
             :updated_at,
             :invited?,
             :invited_users,
             :change_sets

  belongs_to :owner
  has_many :foods

  def invited?
    current_user != object.owner
  end

  def invited_users
    object.invitations.map(&:user)
  end

  def image_url
    "#{ENV['HOSTNAME']}/boxes/#{object.id}/image" if object.image_exists?
  end

  def change_sets
    object.versions.map(&:changeset).reverse
  end
end
