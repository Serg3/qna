require "rails_helper"

RSpec.describe AnswerNotificationMailer, type: :mailer do
  describe "notify" do
    let(:user) { create :user }
    let(:answer) { create(:answer, user: user, question: create(:question, user: user)) }
    let(:mail) { AnswerNotificationMailer.notify(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Notify")
      expect(mail.to).to eq([user.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
