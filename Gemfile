source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "4.0.0"
# Use mysql as the database for Active Record
gem "mysql2"

#default rails group
gem "sass-rails", "~> 4.0.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.0.0"
gem "jquery-rails"
gem "turbolinks"
gem "jbuilder", "~> 1.2"
gem "sdoc", :require => false, :group => [:doc]            # bundle exec rake doc:rails generates the API under doc/api.



# custom gems

gem "devise"
gem "twitter-bootstrap-rails" #, :git => "git://github.com/seyhunak/twitter-bootstrap-rails.git"
gem "simple_form"
gem "cancan"

gem "puma"
gem "foreigner"                                            # Foreigner introduces a few methods to your migrations for adding and removing foreign key constraints. It also dumps foreign keys to schema.rb.
gem "ffaker"                                               # The faker and ffaker APIs are mostly the same, although the API on ffaker keeps growing with its users additions.
gem "factory_girl_rails"                                   # factory_girl is a fixtures replacement with a straightforward definition syntax, support for multiple build strategies
gem "database_cleaner"                                     # database clean library
gem "jquery-fileupload-rails"                              # jquery-fileupload-rails is a library that integrates jQuery File Upload for Rails 3.1 Asset Pipeline
gem "kaminari", :github => "wbyoung/kaminari"              # A Scope & Engine based, clean, powerful, customizable and sophisticated paginator for Rails 4

gem "backbone-rails", "1.0.0.1"

group :development do
  gem "better_errors"                                      # More Flexible Errors Pages
  gem "quiet_assets"                                       # Disable Assets Logger
  gem "pry-rails"                                          # More Flexible Rails Console
end

group :test do
  gem "rspec-rails"
  gem "rspec-instafail"
end