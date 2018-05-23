require_relative '../features_helper'

feature 'Create question', %q{
  I want to be able to
  Ask questions
} do

  given(:user) { create(:user) }

  scenario 'User creates question' do
    sign_in(user)
    visit questions_path

    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: "question's text"
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content "question's text"
  end

  scenario 'User creates question with errors' do
    sign_in(user)
    visit questions_path

    click_on 'Ask question'
    fill_in 'Title', with: ''
    fill_in 'Body', with: ''
    click_on 'Create'

    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
  end

  context 'mulitple sessions' do
    scenario 'question visible for another user', js: true do
      Capybara.using_session('user') do
        sign_in(user)

        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: "question's text"
        click_on 'Create'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end

end
