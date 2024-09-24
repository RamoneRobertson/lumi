class RenameComment < ActiveRecord::Migration[7.1]
  def change
    rename_column :reviews, :comment, :text
  end
end
