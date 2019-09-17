# frozen_string_literal: true

class CreateNotices < ActiveRecord::Migration[5.2]
  def change
    create_table :notices do |t|
      t.string :text, null: false

      t.timestamps
    end

    remove_column :foods, :notice, :text
    add_reference :notices, :food, index: true
  end
end
