# frozen_string_literal: true

class RenameUserColumnToBoxes < ActiveRecord::Migration[5.1]
  def change
    rename_column :boxes, :user_id, :owner_id
  end
end
