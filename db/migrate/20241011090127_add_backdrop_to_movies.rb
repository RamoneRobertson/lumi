class AddBackdropToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :backrop, :string
  end
end
