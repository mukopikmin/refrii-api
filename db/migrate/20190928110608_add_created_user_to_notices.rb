# frozen_string_literal: true

class AddCreatedUserToNotices < ActiveRecord::Migration[5.2]
  def change
    add_reference :notices, :created_user, foreign_key: { to_table: :users }
  end
end
