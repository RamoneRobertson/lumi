class ChangeVoteAvgToFloat < ActiveRecord::Migration[7.1]
  def change
    change_column :movies, :vote_avg, :float
  end
end
