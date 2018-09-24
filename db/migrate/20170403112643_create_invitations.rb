# frozen_string_literal: true

class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.references :box, null: false
      t.references :user, null: false

      t.timestamps
    end
  end
end
