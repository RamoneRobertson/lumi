class RemoveVoteAvgFromMovies < ActiveRecord::Migration[7.1]
  def change
    remove_column :movies, :vote_avg
  end
end
