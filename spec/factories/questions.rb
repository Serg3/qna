FactoryBot.define do
  factory :question do
    title "MyQuestionString"
    body "MyQuestionText"
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
