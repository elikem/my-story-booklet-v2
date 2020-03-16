source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4', '>= 5.2.4.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem "smarter_csv" # Use to import CSV into rails
gem "pundit"
gem "high_voltage", "~> 3.1"
gem "slim-rails"
gem "pagy"
gem "bootstrap", "~> 4.3.1"
gem "friendly_id"
gem "excon"
gem "activerecord-import"
gem "active_link_to"
gem "fog-aws"
gem "csv" # Use to write to CSV
gem "devise"
gem "jquery-rails"
gem "gon"

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "annotate"
  gem "awesome_print"
  gem "forgery"
  gem "meta_request"
  gem "peek"
  gem "peek-pg"
  gem "peek-performance_bar"
  gem "peek-rblineprof"
  gem "peek-gc"
  gem "prettier"
  gem "rails-erd"
  gem "rufo"
  gem "smusher"
  gem "xray-rails" # Not working right now
  gem "better_errors"
  gem "binding_of_caller"
  gem "bullet"
  gem "guard-rails"
  gem "guard-shell"
  gem "guard-bundler"
  gem "terminal-notifier-guard"
  gem "mailcatcher", require: false
  gem "foreman", require: false
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
