class AddTmdbId < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :tmdb_id, :integer
    add_column :movies, :imdb_id, :integer
  end
end
