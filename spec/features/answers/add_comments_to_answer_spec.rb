require_relative "../features_helper"

feature 'Leave comments for answers', %q{
  I want to leave comments
  For answers
  As an authenticated user
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'leave comment', js: true do
    sign_in(user)

    visit question_path(question)

    within '.answers' do
      fill_in 'Comment body', with: 'comment text'
      click_on 'Create Comment'

      expect(page).to have_content 'comment text'
    end
  end

  scenario 'leave a comment with invalid attributes', js: true do
    sign_in(user)

    visit question_path(question)

    within '.answers' do
      fill_in 'Comment body', with: ''
      click_on 'Create Comment'

      expect(page).to have_content "Body can't be blank"
    end
  end

  context 'mulitple sessions' do
    scenario 'comment visible for another user', js: true do
      Capybara.using_session('user') do
        sign_in(user)

        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answers' do
          fill_in 'Comment body', with: 'comment text'
          click_on 'Create Comment'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'comment text'
      end
    end
  end
  
end
