class Movie < ApplicationRecord
  # Validations
  validates :title, :overview,  presence: true
  validates :rating, :runtime, numericality: true
  validates :runtime, numericality: { only_integer: true }
  validates :title, :overview, uniqueness: true


  # Associations
  has_many :bookmarks
  has_many :lists, through: :bookmarks
end
