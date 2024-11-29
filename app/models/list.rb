class List < ApplicationRecord
  belongs_to :user, optional: true
  # validation
  validates :name, uniqueness: true
  validates :name, presence: true
  validates :list_type, presence: true
  enum list_type: { user_list: 0, category_list: 1}

  # Associations
  has_one_attached :photo

  has_many :bookmarks, dependent: :destroy
  has_many :movies, through: :bookmarks
end
