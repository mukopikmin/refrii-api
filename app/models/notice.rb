# frozen_string_literal: true

class Notice < ApplicationRecord
  belongs_to :created_user, class_name: 'User'
end
