require_relative '../features_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User add file to his answer', js: true do
    fill_in 'Body', with: 'answer for question'

    click_link 'Add file'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Create Answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb'
    end
  end

end
