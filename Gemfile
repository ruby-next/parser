# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in parser.gemspec
gemspec name: "parser"

# Workaround for bug in Bundler on JRuby
# See https://github.com/bundler/bundler/issues/4157
gem 'ast', '>= 1.1', '< 3.0'
gem 'racc', '1.8.1'

gem "pry-byebug", platform: :mri
