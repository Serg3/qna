require 'rails_helper'

shared_examples_for 'ratingable' do
  it { should have_many(:ratings).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:resource) { create(:question, user: user) }

  describe '#like(user)' do
    it 'rates to +1' do
      resource.like(user)

      expect(resource.rating).to eq (1)
    end

    it "accepts user's vote" do
      expect { resource.like(user) }.to change(resource.ratings, :count).by(1)
    end
  end

  describe '#dislike(user)' do
    it 'rates to -1' do
      resource.dislike(user)

      expect(resource.rating).to eq (-1)
    end

    it "accepts user's vote" do
      expect { resource.dislike(user) }.to change(resource.ratings, :count).by(1)
    end
  end

  describe '#cancel(user)' do
    it "reverts user's vote" do
      resource.like(user)

      expect { resource.cancel(user) }.to change(resource.ratings, :count).by(-1)
    end
  end

  describe '#rating' do
    it 'returns rating of resource' do
      user2 = create(:user)

      resource.like(user)
      resource.like(user2)

      expect(resource.rating).to eq (2)
    end
  end

  describe '#voted?(user)' do
    it 'user voted' do
      expect(resource.voted?(user)).to be false
    end

    it 'user not voted' do
      resource.like(user)

      expect(resource.voted?(user)).to be true
    end
  end
end
