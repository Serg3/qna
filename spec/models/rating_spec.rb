require 'rails_helper'

RSpec.describe Rating, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:ratingable) }

  it { should validate_presence_of :vote }
  it { should allow_value(1, -1).for(:vote) }
end
