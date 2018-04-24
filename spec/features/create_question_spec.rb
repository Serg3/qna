require 'rails_helper'

feature 'Create question', %q{
  I want to be able to
  Ask questions
} do

  scenario 'User creates question' do
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: "question's text"
    click_on 'Create'
    
    expect(page).to have_content 'Your question successfully created.'
  end

end
