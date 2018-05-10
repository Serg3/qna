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

    fill_in 'Body', with: 'answer for question'

    click_link 'Add file'
    within all('.nested-fields')[0] do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end
  end

  scenario 'User add files to his answer', js: true do
    click_link 'Add file'
    within all('.nested-fields')[1] do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Create Answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end
  end

  describe 'User deletes file', js: true do
    scenario 'while creating answer' do
      click_link 'Delete file'

      click_on 'Create Answer'

      expect(page).to_not have_link 'spec_helper.rb'
    end

    scenario 'after creating answer', js: true do
      click_on 'Create Answer'

      within '.answers' do
        click_link 'Remove file'

        expect(page).to_not have_link 'spec_helper.rb'
      end
    end
  end

end
