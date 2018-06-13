require 'rails_helper'

shared_examples_for 'subscribable' do
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe '#subscribe(user)' do
    it 'add subscriber' do
      resource.subscribe(other_user)

      expect(resource.subscribers).to include(other_user)
    end
  end

  describe '#unsubscribe(user)' do
    it 'remove subscriber' do
      resource.unsubscribe(user)
      
      expect(resource.subscribers).to_not include(user)
    end
  end

  describe '#subscribed?(user)' do
    it 'user subscriber' do
      expect(resource).to_not be_subscribed(other_user)
    end

    it 'user not subscriber' do
      expect(resource).to be_subscribed(user)
    end
  end
end
