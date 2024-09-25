class ChangeRatingInReview < ActiveRecord::Migration[7.1]
  def change
    change_column :reviews, :rating, :float
  end
end
