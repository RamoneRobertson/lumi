class Bookmark < ApplicationRecord
  # Validations
  validates :movie_id, :list_id, presence: true
  validates :movie_id, :list_id, uniqueness: {  scope: :list }

  # Associations
  belongs_to :movie
  belongs_to :list
end
