FactoryBot.define do
  sequence :body do |n|
    "MyAnswerText#{n}"
  end

  factory :answer do
    body
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
