FactoryGirl.define do
  factory :user do
    name { FFaker::Name.name }
    email { 'foobar@example.com' }
    password { 'foobar' }
  end
end
