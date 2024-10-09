class AddBackdropToList < ActiveRecord::Migration[7.1]
  def change
    add_column :lists, :backdrop, :string
  end
end
