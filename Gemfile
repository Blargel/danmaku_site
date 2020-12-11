source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'acts-as-taggable-on'
gem 'authlogic'
gem 'aws-sdk-s3', require: false
gem 'bootsnap', '>= 1.4.2', require: false
gem 'cancancan'
gem 'formtastic', '~> 4.0.0.rc1', require: 'formtastic'
gem 'haml-rails'
gem 'image_processing', '~> 1.2'
gem 'inherited_resources'
gem 'jbuilder', '~> 2.7'
gem 'mini_magick'
gem 'paperclip'
gem 'permalink_fu'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
gem 'recaptcha'
gem 'sass-rails', '>= 6'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'webpacker', '~> 4.0'
gem 'will_paginate'
gem 's3_swf_upload', require: 's3_swf_upload/view_helpers'

# Apple Silicon fix
gem 'ffi', github: 'felipecsl/ffi', ref: '17dbdfc43d1f6db1cbd2ff14635ffa1a620380a6'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'rubocop'
end

group :development do
  gem 'foreman'
  gem 'listen', '~> 3.2'
  gem 'solargraph'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end
