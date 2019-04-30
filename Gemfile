source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'faker', '~> 1.8'
gem 'fast_jsonapi'
gem 'jbuilder', '~> 2.5'
gem 'pg'
gem 'postmark'
gem 'puma', '~> 3.11'
gem 'rack-cors', '~> 1.0'
gem 'rails', '~> 5.2.0'
gem 'rails_admin', '~> 1.3'
gem 'stripe'

group :development, :test do
  gem 'pry'
end

group :development do
  gem 'annotate'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner', '~> 1.6.2'
  gem 'fabrication', '~> 2.19'
  gem 'rails-controller-testing'
  gem 'rspec', '~> 3.7'
  gem 'rspec-mocks'
  gem 'rspec-rails', '~> 3.7'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
