# frozen_string_literal: true

class PushToken < ApplicationRecord
  belongs_to :user

  def exists?
    PushToken.exists?(token: token)
  end
end
