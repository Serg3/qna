require_relative '../features_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As a question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text of question'

    click_link 'Add file'
    within all('.nested-fields')[0] do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end
  end

  scenario 'User add files when asks question', js: true do
    click_link 'Add file'
    within all('.nested-fields')[1] do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb'
  end

  describe 'User deletes file', js: true do
    scenario 'while creating answer' do
      click_link 'Delete file'

      click_on 'Create'

      expect(page).to_not have_link 'spec_helper.rb'
    end

    scenario 'after creating answer', js: true do
      click_on 'Create'

      click_link 'Remove file'

      expect(page).to_not have_link 'spec_helper.rb'
    end
  end

end
