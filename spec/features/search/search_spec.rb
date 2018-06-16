require_relative '../features_helper'

feature 'Search', %q{
  To find some data
  In web-application
  I want to perform a search
} do

  given(:user) { create(:user) }

  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  given!(:question_comment) { create(:comment, user: user, commentable: answer) }
  given!(:answer_comment) { create(:comment, user: user, commentable: question) }

  scenario 'Empty search via all category', js: true do
    ThinkingSphinx::Test.run do
      visit search_index_path

      click_button 'Search'

      expect(page).to have_link question.title
      expect(page).to have_link answer.body
      expect(page).to have_link answer_comment.body
      expect(page).to have_link question_comment.body
      expect(page).to have_content user.email
    end
  end

  scenario 'Not found', js: true do
    ThinkingSphinx::Test.run do
      visit search_index_path

      fill_in 'query', with: 'find something'
      click_button 'Search'

      expect(page).to have_content 'No results found for find something.'
    end
  end

  scenario 'Non empty search via all category', js: true do
    ThinkingSphinx::Test.run do
      visit search_index_path

      fill_in 'query', with: question.title
      click_button 'Search'

      expect(page).to have_link question.title
      expect(page).to_not have_link answer.body
      expect(page).to_not have_link question_comment.body
      expect(page).to_not have_link answer_comment.body
      expect(page).to_not have_content user.email
    end
  end

  scenario 'Category question', js: true do
    ThinkingSphinx::Test.run do
      visit search_index_path

      select 'Questions', from: 'category'
      click_button 'Search'

      expect(page).to have_link question.title
      expect(page).to_not have_link answer.body
      expect(page).to_not have_link question_comment.body
      expect(page).to_not have_link answer_comment.body
      expect(page).to_not have_content user.email
    end
  end

  scenario 'Category answer', js: true do
    ThinkingSphinx::Test.run do
      visit search_index_path

      select 'Answers', from: 'category'
      click_button 'Search'

      expect(page).to_not have_link question.title
      expect(page).to have_link answer.body
      expect(page).to_not have_link question_comment.body
      expect(page).to_not have_link answer_comment.body
      expect(page).to_not have_content user.email
    end
  end

  scenario 'Category comment', js: true do
    ThinkingSphinx::Test.run do
      visit search_index_path

      select 'Comments', from: 'category'
      click_button 'Search'

      expect(page).to_not have_link question.title
      expect(page).to_not have_link answer.body
      expect(page).to have_link question_comment.body
      expect(page).to have_link answer_comment.body
      expect(page).to_not have_content user.email
    end
  end

  scenario 'Category user', js: true do
    ThinkingSphinx::Test.run do
      visit search_index_path

      select 'Users', from: 'category'
      click_button 'Search'

      expect(page).to_not have_link question.title
      expect(page).to_not have_link answer.body
      expect(page).to_not have_link question_comment.body
      expect(page).to_not have_link answer_comment.body
      expect(page).to have_content user.email
    end
  end
end
