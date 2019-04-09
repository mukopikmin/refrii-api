# frozen_string_literal: true

class CreatePushTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :push_tokens do |t|
      t.string :token, null: false

      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
