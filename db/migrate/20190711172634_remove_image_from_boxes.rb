# frozen_string_literal: true

class RemoveImageFromBoxes < ActiveRecord::Migration[5.2]
  def change
    remove_column :boxes, :image_file, :binary
    remove_column :boxes, :image_size, :integer
    remove_column :boxes, :image_content_type, :string
  end
end
