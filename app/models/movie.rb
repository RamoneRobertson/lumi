class Movie < ApplicationRecord
  # Validations
  validates :title, :overview,  presence: true
  validates :rating, :runtime, numericality: true
  validates :title, :overview, uniqueness: true


  # Associations
  has_many :bookmarks
  has_many :lists, through: :bookmarks

  # Add tags for genres
  ActsAsTaggableOn.force_lowercase = true
  acts_as_taggable_on :tags
  acts_as_taggable_on :genres
end
