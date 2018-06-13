require 'rails_helper'

RSpec.describe AnswerNotificationJob, type: :job do
  let!(:user) { create(:user) }
  let!(:users) { create_list(:user, 5) }

  let!(:question) { create(:question, user: user) }
  let!(:answer) {create(:answer, question: question, user: user)}

  it 'notifies for the new answer' do
    question.unsubscribe(user)

    expect(AnswerNotificationMailer).to_not receive(:notify).with(user, answer).and_call_original

    users.each do |user|
      question.subscribe(user)
      
      expect(AnswerNotificationMailer).to receive(:notify).with(user, answer).and_call_original
    end

    AnswerNotificationJob.perform_now(answer)
  end
end
