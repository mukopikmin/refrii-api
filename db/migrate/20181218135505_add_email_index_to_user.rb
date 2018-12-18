# frozen_string_literal: true

class AddEmailIndexToUser < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :email, name: 'index_users_on_email'
  end
end
