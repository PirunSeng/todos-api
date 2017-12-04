FactoryGirl.define do
  factory :item do
    name { FFaker::Lorem.word }
    done false
    todo_id nil
  end
end
