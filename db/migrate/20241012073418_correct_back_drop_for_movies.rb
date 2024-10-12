class CorrectBackDropForMovies < ActiveRecord::Migration[7.1]
  def change
    rename_column :movies, :backrop, :backdrop
  end
end
