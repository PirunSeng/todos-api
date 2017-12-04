FactoryGirl.define do
  factory :todo do
    title { FFaker::Lorem.word }
    created_by { rand(1..10) }
  end
end
