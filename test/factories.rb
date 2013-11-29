FactoryGirl.define do
  sequence :email do |n|
    "username-#{n}@gmail.com"
  end

  sequence :username do |n|
    "username-#{n}"
  end

  factory :player do
    username    
    email       
    password    'passpass'
    password_confirmation 'passpass'
  end

  factory :group do
    name        'group-1'
  end
end