module Ratingable
  extend ActiveSupport::Concern

  included do
    has_many :ratings, as: :ratingable, dependent: :destroy
  end

  def like(user)
    ratings.create!(vote: 1, user: user)
  end

  def dislike(user)
    ratings.create!(vote: -1, user: user)
  end

  def cancel(user)
    ratings.where(user: user).delete_all
  end

  def rating
    ratings.sum(:vote)
  end

  def voted?(user)
    ratings.exists?(user: user)
  end
end
