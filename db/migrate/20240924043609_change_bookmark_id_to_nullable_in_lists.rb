class ChangeBookmarkIdToNullableInLists < ActiveRecord::Migration[7.1]
  def change
    change_column_null :lists, :bookmark_id, true
  end
end
