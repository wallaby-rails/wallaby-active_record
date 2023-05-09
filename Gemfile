# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.1.2'

# Specify your gem's dependencies in wallaby-active_record.gemspec
gemspec

gem 'rails', '~> 7.0.0'
gem 'sassc'

gem 'mysql2'
gem 'pg'
gem 'sqlite3'
# gem 'sqlite3', '< 1.4.0'

gem 'cancancan'
gem 'pundit'

gem 'better_errors'
gem 'byebug'
gem 'deep-cover'
gem 'simplecov', '~> 0.17.0'

gem 'wallaby-cop', path: '../wallaby-cop'
gem 'wallaby-core', path: '../wallaby-core'

# target_branch = !ENV['GITHUB_BASE_REF']&.empty? && ENV['GITHUB_BASE_REF']
# target_branch ||= !ENV['GITHUB_REF_NAME']&.empty? && ENV['GITHUB_REF_NAME']
# target_branch ||= 'develop'

# gem 'wallaby-core', git: 'https://github.com/wallaby-rails/wallaby-core.git', branch: target_branch
# gem 'wallaby-cop', git: 'https://github.com/wallaby-rails/wallaby-cop.git', branch: 'main'
