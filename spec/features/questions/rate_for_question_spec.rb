require_relative "../features_helper"

feature 'Rate for question', %q{
  All authorized users
  Expect an author of question
  Can rate for this question
} do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user2) }

  describe 'Authorized user' do
    before do
      sign_in(user1)
      visit question_path(question)
    end

    scenario 'likes question', js: true do
      click_on 'like'

      expect(page).to_not have_link 'like'
      expect(page).to_not have_link 'dislike'
      expect(page).to have_link 'cancel'
      expect(page).to have_content '1'
    end

    scenario 'dislikes question', js: true do
      click_on 'dislike'

      expect(page).to_not have_link 'like'
      expect(page).to_not have_link 'dislike'
      expect(page).to have_link 'cancel'
      expect(page).to have_content '-1'
    end

    scenario 'cancels self vote', js: true do
      click_on 'like'
      click_on 'cancel'

      expect(page).to have_link 'like'
      expect(page).to have_link 'dislike'
      expect(page).to_not have_link 'cancel'
      expect(page).to have_content '0'
    end
  end

  scenario 'Unauthorized user want likes question', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'like'
    expect(page).to_not have_link 'dislike'
    expect(page).to_not have_link 'cancel'
    expect(page).to have_content '0'
  end

end
