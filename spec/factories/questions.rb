FactoryBot.define do
  sequence :title do |n|
    "MyQuestionTitle#{n}"
  end

  factory :question do
    title
    body "MyQuestionText"
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
