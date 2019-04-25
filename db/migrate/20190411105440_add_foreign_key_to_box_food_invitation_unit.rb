# frozen_string_literal: true

class AddForeignKeyToBoxFoodInvitationUnit < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :boxes, :users, column: :owner_id
    add_foreign_key :foods, :boxes, column: :box_id
    add_foreign_key :foods, :untis, column: :unit_id
    add_foreign_key :invitations, :boxes, column: :box_id
    add_foreign_key :invitations, :users, column: :user_id
    add_foreign_key :units, :users, column: :user_id
  end
end
