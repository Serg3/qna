class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable

  validates :body, presence: :true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :by_best, -> { order(best: :desc, created_at: :desc) }

  def set_best
    current_best = question.answers.find_by(best: true)

    transaction do
      current_best.update!(best: false) if current_best
      update!(best: true)
    end
  end
end
