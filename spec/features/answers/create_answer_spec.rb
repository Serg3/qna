require "rails_helper"

feature 'Create answer', %q{
  I want to be able to
  Write answer for question
  In question's page
} do

  scenario 'Create answer' do
    question = create(:question)

    visit question_path(question)

    fill_in 'Body', with: 'Answer for question'
    click_on 'Create Answer'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'Answer for question'
  end

  scenario 'Create answer with errors' do
    question = create(:question)
    
    visit question_path(question)

    fill_in 'Body', with: ''
    click_on 'Create Answer'

    expect(page).to have_content "Body can't be blank"
  end

end
