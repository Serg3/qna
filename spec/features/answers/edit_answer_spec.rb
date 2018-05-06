require_relative '../features_helper'

feature 'Edit answer', %q{
  I want to be able to
  Edit my answers only
  When authenticated
} do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user1) }

  describe 'Authenticated user' do
    before { sign_in(user1) }

    scenario "Edit user's answer", js: true do
      answer = create(:answer, user: user1, question: question)

      visit question_path(question)

      click_on 'Edit'
      
      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to have_no_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
      expect(page).to have_content 'Your answer successfully updated.'
    end

    scenario "Edit another user's answer", js: true do
      create(:answer, user: user2, question: question)

      visit question_path(question)

      expect(page).to have_no_content 'Edit'
    end
  end

  scenario "Unauthorized user tries to edit answer", js: true do
    create(:answer, user: user2, question: question)

    visit question_path(question)

    expect(page).to have_no_link 'Edit'
  end

end
