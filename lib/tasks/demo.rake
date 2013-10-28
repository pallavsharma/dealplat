require 'factory_girl_rails'
require 'ffaker'
require 'database_cleaner'

namespace :demo do

  desc 'Create Demo Data'
  task :seed => :environment do
    #{ :email => 'web.alex.leontev@gmail.com', :name => 'Alex',   :password => '123123', :confirmed_at => Time.now, :is_admin => true }
    User.create!([
                     { :email => 'web.alex.leontev@gmail.com', :name => 'Alex',   :password => '123123', :is_admin => true }
                 ])

    factory_girl_entity_counts = {}

    if Rails.env.production?
      factory_girl_entity_counts.merge!({
                                            :user => 100,
                                            :marker => 600
                                        })
    else
      factory_girl_entity_counts.merge!({
                                            :user => 100,
                                            :marker => 600
                                        })
    end

    factory_girl_entity_counts.each { |key, value| value.times { FactoryGirl.create(key) } }

  end


  desc 'Clear Demo Data'
  task :clear => :environment do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end


end