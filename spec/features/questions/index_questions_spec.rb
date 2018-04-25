require 'rails_helper'

feature 'Show all questions', %q{
  I want to be able to
  See all questions
} do

  given(:user) { create(:user) }

  scenario 'Index questions' do
    questions = create_list(:question, 2, user: user)
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

end
