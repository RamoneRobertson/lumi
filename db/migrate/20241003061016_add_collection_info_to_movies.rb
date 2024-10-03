class AddCollectionInfoToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :collection_id, :integer
    add_column :movies, :collection_poster, :string
  end
end
