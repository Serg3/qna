FactoryBot.define do
  factory :answer do
    body "MyAnswerText"
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
