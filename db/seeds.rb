# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#   rake: bundle exec rake db:{drop,create,migrate,seed}



Rake::Task["demo:clear"].execute



Marker::Category.create!([
                             {:name => 'Restaurant' },
                             {:name => 'Shop'},
                             {:name => 'Bar'},
                             {:name => 'Gym'}
                         ])




Rake::Task["demo:seed"].execute