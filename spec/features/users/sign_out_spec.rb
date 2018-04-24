require 'rails_helper'

feature 'Sign out users', %{
  In order to be able
  An authorized user
  I want to sign out
} do

  given(:user) { create(:user) }

  scenario 'sign out' do
    sign_in(user)
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end

end
