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
    # p object.avatar
    # p  url_for(object.avatar)
    object.avatar.attached? ? url_for(object.avatar) : nil
  end
end
