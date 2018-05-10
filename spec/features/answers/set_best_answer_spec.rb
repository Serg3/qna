require_relative "../features_helper"

feature 'Choose a best answers', %q{
  Only an author of question
  Can set one of answers
  As the best answer
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    scenario 'An author set the best answer', js: true do
      sign_in(user)

      visit question_path(question)

      within ".answer_#{answer.id}" do
        click_link "The best"
        expect(page).to_not have_link "The best"
      end
    end

    scenario 'A non author of question tries to set the best answer' do
      sign_in(other_user)

      visit question_path(question)

      expect(page).to_not have_link "The best"
    end
  end

  scenario 'Unauthenticated user tries to set the best answer' do
    visit question_path(question)

    expect(page).to_not have_link "The best"
  end
  
end
