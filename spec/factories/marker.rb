FactoryGirl.define do

  factory :marker, :class => Marker do
    user_id { User.random_record_id }
    marker_category_id { Marker::Category.random_record_id }
    title { Faker::Address.city}
    description  { Faker::Address.street_name }
    latitude { rand(-90.0..90.0) }
    longitude { rand(-90.0..90.0) }

  end

end