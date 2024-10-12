class RenamePopularityForMovie < ActiveRecord::Migration[7.1]
  def change
    rename_column :movies, :poplarity, :popularity
  end
end
