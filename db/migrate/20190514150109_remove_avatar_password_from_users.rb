class RemoveAvatarPasswordFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :avatar_file, :binary
    remove_column :users, :avatar_size, :integer
    remove_column :users, :avatar_content_type, :string
    remove_column :users, :password_digest, :string
  end
end
