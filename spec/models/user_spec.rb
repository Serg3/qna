require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  describe "#author_of?(resource)" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, user: user1) }

    it "user is an author of question" do
      expect(user1.author_of?(question)).to eq true
    end
    it "user is not an author of question" do
      expect(user2.author_of?(question)).to eq false
    end
  end
end
