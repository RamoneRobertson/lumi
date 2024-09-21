class AddListsToBookmarks < ActiveRecord::Migration[7.1]
  def change
    add_reference :bookmarks, :list, foreign_key: true
  end
end
