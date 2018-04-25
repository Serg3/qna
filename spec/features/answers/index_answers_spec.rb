require "rails_helper"

feature 'Show all answers for question', %q{
  I want to be able to
  See all answers for question
  In question's page
} do

  given(:user) { create(:user) }

  scenario 'Index answers for question' do
    @question = create(:question, user: user)
    @answers = create_list(:answer, 2, question: @question, user: user)

    visit question_path(@question)

    expect(page).to have_content @question.title
    @answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

end
