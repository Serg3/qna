require_relative "../features_helper"

feature 'Subscribe for a question', %q{
  To receive notifications for new answers to question
  As an authenticated user
  I want to subscribe for a question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_question) { create(:question, user: create(:user)) }

  before do
    sign_in(user)
  end

  scenario 'User can subscribes for a question' do
    visit question_path(other_question)

    click_on 'Subscribe'

    expect(page).to have_content 'You have successfully subscribed.'
    expect(page).to_not have_link 'Subscribe'
    expect(page).to have_link 'Unsubscribe'
  end

  scenario 'User can unsubscribes from question' do
    visit question_path(other_question)

    click_on 'Subscribe'
    click_on 'Unsubscribe'

    expect(page).to have_content 'You have successfully unsubscribed.'
    expect(page).to_not have_link 'Unubscribe'
    expect(page).to have_link 'Subscribe'
  end

  scenario 'User can unsubscribes from his question' do
    visit question_path(question)

    click_on 'Unsubscribe'

    expect(page).to have_content 'You have successfully unsubscribed.'
    expect(page).to_not have_link 'Unubscribe'
    expect(page).to have_link 'Subscribe'
  end
end
