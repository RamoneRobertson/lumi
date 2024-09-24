class Bookmark < ApplicationRecord
  # Validations
  validates :movie_id, :list_id, presence: true
  validates :list_id, uniqueness: {  scope: :movie_id, message: "This movie is already in the list" }
  validates :comment, length: { minimum: 6 }

  # Associations
  belongs_to :movie
  belongs_to :list
end
