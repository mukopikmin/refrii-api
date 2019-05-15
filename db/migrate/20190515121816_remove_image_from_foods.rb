# frozen_string_literal: true

class RemoveImageFromFoods < ActiveRecord::Migration[5.2]
  def change
    remove_column :foods, :image_file, :binary
    remove_column :foods, :image_size, :integer
    remove_column :foods, :image_content_type, :string
    remove_column :foods, :needs_adding, :boolean
  end
end
