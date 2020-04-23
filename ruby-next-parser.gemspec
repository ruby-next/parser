# frozen_string_literal: true

require_relative "lib/parser/ruby-next/version"

Gem::Specification.new do |s|
  s.name = "ruby-next-parser"
  s.version = Parser::NEXT_VERSION
  s.authors = ["Vladimir Dementyev"]
  s.email = ["dementiev.vm@gmail.com"]
  s.homepage = "http://github.com/ruby-next/parser"
  s.summary = "Parser extension to support edge and experimental Ruby syntax"
  s.description = %(
    Parser extension to support edge and experimental Ruby syntax
  )

  s.metadata = {
    "homepage_uri" => "http://github.com/parser/ruby-next",
    "source_code_uri" => "http://github.com/parser/ruby-next"
  }

  s.license = "MIT"

  s.files = Dir.glob("lib/parser/ruby-next/**/*") + Dir.glob("lib/parser/rubynext.*")
  s.required_ruby_version = ">= 2.4.0"

  s.require_paths = ["lib"]

  s.add_dependency "parser", ">= 2.7.0.5"
end
