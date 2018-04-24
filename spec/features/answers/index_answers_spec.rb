require "rails_helper"

feature 'Show all answers for question', %q{
  I want to be able to
  See all answers for question
  In question's page
} do

  scenario 'Index answers for question' do
    @question = create(:question)
    @answer = create(:answer, { question_id: @question.id })

    visit question_path(@question)

    expect(page).to have_content @question.title
    expect(page).to have_content @answer.body
  end

end
