FactoryGirl.define do 
  factory :user do 
    sequence(:first_name) { |n| "John-#{n}" }
    last_name   "Doe"
    sequence(:email) { |n| "john-#{n}.doe@gmail.com" }
    password "secret"
    password_confirmation "secret"
 end
end
