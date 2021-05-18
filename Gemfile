source 'https://rubygems.org'
ruby File.read(File.join(File.dirname(__FILE__), '.ruby-version')).strip
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'acts_as_list'
gem 'acts-as-taggable-on', '~> 6.0'
gem 'andand'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'cocoon', '~> 1.2.11'
gem "fog-google", '~> 1.8'
gem 'carrierwave'
gem 'devise'
gem 'factory_bot_rails'
gem 'faker'
gem 'friendly_id', '~> 5.1.0'
gem 'image_processing', '~> 1.2'
gem 'jbuilder', '~> 2.5'
gem 'mimemagic', '0.4.3' # Smarter detection of mime types in file uploads
gem 'pg'
gem 'pg_search'
gem 'puma', '~> 5.3'
gem 'rails', '~> 5.2.5'
gem 'rails_admin', git: 'git://github.com/sferik/rails_admin.git', branch: 'master'
gem 'redcarpet'
gem 'sass-rails', '~> 5.0'
gem 'simplemde-rails'
gem 'skylight'
gem 'slim-rails'
gem 'uglifier', '>= 1.3.0'
# secret_key_base
# Profiling
gem 'flamegraph'
gem 'rack-mini-profiler', require: false
gem 'stackprof'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'coveralls', require: false
  gem 'rspec-rails'
end

group :development do
  gem 'annotate'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '~> 2.15'
  gem 'chromedriver-helper'
  gem 'rspec_junit_formatter'
  gem 'selenium-webdriver'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
