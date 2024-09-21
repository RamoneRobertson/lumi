class CreateMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :overview
      t.string :poster_url
      t.decimal :rating
      t.string :trailer_url
      t.decimal :vote_avg
      t.date :release_date
      t.integer :runtime

      t.timestamps
    end
  end
end
