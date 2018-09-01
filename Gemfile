source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.4.0'

gem 'acts-as-taggable-on', '~> 6.0'
gem 'andand'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'devise'
gem 'faker'
gem 'factory_bot'
gem 'factory_bot_rails'
gem 'friendly_id', '~> 5.1.0'
gem 'image_processing', '~> 1.2'
gem 'jbuilder', '~> 2.5'
gem 'pg'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.0'
gem 'rails_admin', git: 'git://github.com/sferik/rails_admin.git', branch: 'master'
gem 'redcarpet'
gem 'sass-rails', '~> 5.0'
gem 'simplemde-rails'
gem 'skylight'
gem 'slim-rails'
gem 'sqlite3'
gem 'uglifier', '>= 1.3.0'

# Profiling
gem 'flamegraph'
gem 'rack-mini-profiler', require: false
gem 'stackprof'


group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'coveralls', require: false
end

group :development do
  gem 'annotate'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '~> 2.15'
  gem 'chromedriver-helper'
  gem 'selenium-webdriver'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
