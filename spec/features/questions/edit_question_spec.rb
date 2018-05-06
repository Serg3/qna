require_relative '../features_helper'

feature 'Edit question', %q{
  I want to be able to
  Edit my question only
  When authenticated
} do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user1) }

  describe 'Authenticated user' do
    scenario "Edit user's question", js: true do
      sign_in(user1)

      visit question_path(question)

      click_on 'Edit question'

      within ".question_#{question.id}" do
        fill_in 'Title', with: 'edited question title'
        fill_in 'Body', with: 'edited question body'
        click_on 'Save'

        expect(page).to have_no_content question.title
        expect(page).to have_no_content question.body
        expect(page).to have_content 'edited question title'
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_selector 'textarea'
      end
      expect(page).to have_content 'Your question successfully updated.'
    end

    scenario "Edit another user's question", js: true do
      sign_in(user2)

      visit question_path(question)

      expect(page).to have_no_content 'Edit question'
    end
  end

  scenario "Unauthorized user tries to edit question", js: true do
    visit question_path(question)

    expect(page).to have_no_link 'Edit question'
  end

end
