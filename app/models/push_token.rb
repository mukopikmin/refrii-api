# frozen_string_literal: true

class PushToken < ApplicationRecord
  belongs_to :user

  validates_presence_of :token
  validates_presence_of :user

  def exists?
    PushToken.exists?(token: token)
  end
end
