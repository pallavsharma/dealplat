FactoryGirl.define do

  factory :user, :class => User do
    email                 { Faker::Internet.email }
    name                  { Faker::Name.name }
    password              { "123123" }
    #confirmed_at          { Time.now }
  end

end