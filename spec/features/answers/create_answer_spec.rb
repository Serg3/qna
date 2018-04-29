require "rails_helper"

feature 'Create answer', %q{
  I want to be able to
  Write answer for question
  In question's page
} do

  given(:user) { create(:user) }

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

end
