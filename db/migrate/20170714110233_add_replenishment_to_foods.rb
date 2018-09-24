# frozen_string_literal: true

class AddReplenishmentToFoods < ActiveRecord::Migration[5.1]
  def change
    add_column :foods, :needs_adding, :boolean, default: false
  end
end
