class Review < ApplicationRecord
  # Validations
  validates :text, length: { in: 6..256 }
  validates :user_id, :movie_id, presence: true

  # Associations
  belongs_to :user
  belongs_to :movie
end
