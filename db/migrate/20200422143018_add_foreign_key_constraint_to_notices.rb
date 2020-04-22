# frozen_string_literal: true

class AddForeignKeyConstraintToNotices < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :notices, :foods, column: :food_id
  end
end
