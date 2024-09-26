class RemoveBookmarkAndUser < ActiveRecord::Migration[7.1]
  def change
    remove_column :lists, :bookmark_id
    remove_column :lists, :user_id
  end
end
