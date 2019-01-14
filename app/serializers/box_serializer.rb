# frozen_string_literal: true

class BoxSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :notice,
             :image_url,
             :created_at,
             :updated_at,
             :is_invited,
             :invited_users
  #  :change_sets

  belongs_to :owner
  has_many :foods

  def is_invited
    current_user != object.owner
  end

  def invited_users
    object.invitations.map(&:user)
          .map { |user| UserSerializer.new(user) }
  end

  def image_url
    "#{ENV['HOSTNAME']}/boxes/#{object.id}/image" if object.image_exists?
  end

  # def change_sets
  #   object.versions.map(&:changeset).reverse
  # end
end
