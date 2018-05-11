require_relative "../features_helper"

feature 'Rate for answer', %q{
  All authorized users
  Expect an author of answer
  Can rate for this answer
} do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user2) }
  given!(:answer) { create(:answer, user: user2, question: question) }

  describe 'Authorized user' do
    before do
      sign_in(user1)
      visit question_path(question)
    end

    scenario 'likes answer', js: true do
      within '.answers' do
        click_on 'like'

        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
        expect(page).to have_link 'cancel'
        expect(page).to have_content '+1'
      end
    end

    scenario 'dislikes answer', js: true do
      within '.answers' do
        click_on 'dislike'

        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
        expect(page).to have_link 'cancel'
        expect(page).to have_content '-1'
      end
    end

    scenario 'cancels self vote', js: true do
      within '.answers' do
        click_on 'like'
        click_on 'cancel'

        expect(page).to have_link 'like'
        expect(page).to have_link 'dislike'
        expect(page).to_not have_link 'cancel'
        expect(page).to have_content '0'
      end
    end
  end

  scenario 'Unauthorized user want likes answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'like'
    expect(page).to_not have_link 'dislike'
    expect(page).to_not have_link 'cancel'
    expect(page).to have_content '0'
  end

end
