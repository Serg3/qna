require 'rails_helper'

feature 'Show all questions', %q{
  I want to be able to
  See all questions
} do

  scenario 'Index questions' do
    question = create(:question)
    visit questions_path

    expect(page).to have_content question.title
  end

end
