# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :email,
             :provider,
             :disabled,
             :admin,
             :avatar_url,
             :created_at,
             :updated_at

  def avatar_url
    "#{ENV['HOSTNAME']}/users/#{object.id}/avatar" if object.avatar_exists?
  end
end
