class Question < ApplicationRecord
  include Ratingable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachable

  validates :title, :body, presence: :true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
