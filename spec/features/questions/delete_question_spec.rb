require 'rails_helper'

feature 'Delete question', %q{
  I want to be able to
  Delete my questions
  When authenticated
} do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }

  scenario "Delete user's question" do
    sign_in(user1)
    question = create(:question, user: user1)

    visit questions_path

    click_on 'Delete'

    expect(page).to have_content 'Your question successfully deleted.'
    expect(page).to have_no_content question.title
  end

  scenario "Delete another user's question" do
    sign_in(user1)

    visit questions_path

    expect(page).to have_no_content 'Delete'
  end

end
