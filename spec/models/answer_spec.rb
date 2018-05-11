require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to :question }
  it { should have_many(:attachments) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  it_behaves_like 'ratingable'

  describe '#set_best' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let!(:best_answer) { create(:answer, question: question, user: user, best: true) }

    it 'the answer set as best' do
      answer.set_best

      expect(answer).to be_best
    end

    it "set another answer as best" do
      answer.set_best
      best_answer.reload

      expect(best_answer).to_not be_best
    end
  end
end
