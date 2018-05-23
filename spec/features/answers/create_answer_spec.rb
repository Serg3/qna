require_relative '../features_helper'

feature 'Create answer', %q{
  I want to be able to
  Write answer for question
  In question's page
} do

  given(:user) { create(:user) }
  given!(:question2) { create(:question, user: user) }

  scenario 'Create answer', js: true do
    sign_in(user)
    question = create(:question, user: user)

    visit question_path(question)

    fill_in 'Body', with: 'Answer for question'
    click_on 'Create Answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Your answer successfully created.'
    within '.answers' do
      expect(page).to have_content 'Answer for question'
    end
  end

  scenario 'Create answer with errors', js: true do
    sign_in(user)
    question = create(:question, user: user)

    visit question_path(question)

    fill_in 'Body', with: ''
    click_on 'Create Answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content "Body can't be blank"
    within '.answers' do
      expect(page).to have_no_content 'Answer for question'
    end
  end

  context 'mulitple sessions' do
    scenario 'answer visible for another user', js: true do
      Capybara.using_session('user') do
        sign_in(user)

        visit question_path(question2)
      end

      Capybara.using_session('guest') do
        visit question_path(question2)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'answer text'
        click_on 'Create Answer'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'answer text'
      end
    end
  end

end
