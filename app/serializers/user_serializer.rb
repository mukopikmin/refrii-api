# frozen_string_literal: true

class UserSerializer < ApplicationRecordSerializer
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
    object.avatar.attached? ? url_for(object.avatar) : nil
  end
end
