class AddListTypeToLists < ActiveRecord::Migration[7.1]
  def change
    add_column :lists, :list_type, :integer
  end
end
