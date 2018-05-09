FactoryBot.define do
  factory :attachment do
    file { Rack::Test::UploadedFile.new("#{Rails.root}/spec/spec_helper.rb") }
  end
end
