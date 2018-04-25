require 'rails_helper'

feature 'Delete answer', %q{
  I want to be able to
  Delete my answers
  When authenticated
} do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }

  scenario "Delete user's answer" do
    sign_in(user1)
    question = create(:question, user: user1)
    answer = create(:answer, user: user1, question: question)

    visit question_path(question)

    click_on 'Delete'

    expect(page).to have_content 'Your answer successfully deleted.'
    expect(page).to have_no_content answer.body
  end

  scenario "Delete another user's answer" do
    sign_in(user1)
    question = create(:question, user: user1)
    create(:answer, user: user2, question: question)

    visit question_path(question)

    expect(page).to have_no_content 'Delete'
  end

  scenario "Unauthorized user deletes answer" do
    question = create(:question, user: user1)
    create(:answer, user: user2, question: question)

    visit question_path(question)

    expect(page).to have_no_content 'Delete'
  end

end
