class List < ApplicationRecord
  # validation
  validates :name, uniqueness: true
  validates :name, presence: true

  # Associations
  has_one_attached :photo

  has_many :bookmarks, dependent: :destroy
  has_many :movies, through: :bookmarks
end
