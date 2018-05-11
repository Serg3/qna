class Rating < ApplicationRecord
  belongs_to :ratingable, polymorphic: true
  belongs_to :user

  validates :vote, presence: true, inclusion: [1, -1]
end
