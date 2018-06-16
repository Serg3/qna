require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.find' do
    %w(Questions Answers Comments Users).each do |attr|
      it "for category: #{attr}" do
        expect(attr.classify.constantize).to receive(:search).with('find something')

        Search.find('find something', attr)
      end
    end

    it "for category: All" do
      expect(ThinkingSphinx).to receive(:search).with('find something')

      Search.find('find something', 'All')
    end
  end
end
