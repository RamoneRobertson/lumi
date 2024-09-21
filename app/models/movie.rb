class Movie < ApplicationRecord
  # Validations
  validates :title, :overview, :poster_url, :release_date, presence: true
  validates :rating, :runtime, numericality: true
  validates :runtime, numericality: { only_integer: true }

  # Associations
  has_many :bookmarks
  has_many :lists, through: :bookmarks
end
