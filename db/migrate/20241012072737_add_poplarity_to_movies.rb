class AddPoplarityToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :poplarity, :float
  end
end
