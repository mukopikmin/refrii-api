# frozen_string_literal: true

class BoxSerializer < ApplicationRecordSerializer
  attributes :id,
             :name,
             :notice,
             :image_url,
             :created_at,
             :updated_at,
             :is_invited,
             :invited_users

  belongs_to :owner

  # rubocop:disable Naming/PredicateName
  def is_invited
    current_user != object.owner
  end
  # rubocop:enable Naming/PredicateName

  def invited_users
    object.invitations
          .map(&:user)
          .map { |user| UserSerializer.new(user) }
  end

  def image_url
    "#{ENV['HOSTNAME']}/boxes/#{object.id}/image" if object.image_exists?
  end
end
