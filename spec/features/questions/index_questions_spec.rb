require 'rails_helper'

feature 'Show all questions', %q{
  I want to be able to
  See all questions
} do

  given(:user) { create(:user) }

  scenario 'Index questions' do
    question = create(:question, user: user)
    visit questions_path

    expect(page).to have_content question.title
  end

end
