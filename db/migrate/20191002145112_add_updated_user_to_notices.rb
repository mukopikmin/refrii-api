class AddUpdatedUserToNotices < ActiveRecord::Migration[5.2]
  def change
    add_reference :notices, :updated_user, foreign_key: { to_table: :users }
    change_column :notices, :updated_user_id, :integer, null: false
  end
end
