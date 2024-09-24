class ChangeUserIdToNullableInLists < ActiveRecord::Migration[7.1]
  def change
    change_column_null :lists, :user_id, true
  end
end
