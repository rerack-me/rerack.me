FactoryGirl.define do
  factory :player do
    username    'player-1'
    email       'player-1@gmail.com'
    password    'passpass'
    password_confirmation 'passpass'
  end

  factory :group do
    name        'group-1'
  end
end