ifdef VERSION
else
	VERSION := $(shell sh -c 'ruby -r ./lib/parser/version.rb -e "matches = Parser::VERSION.match(/(.+)\.(\d+)\Z/); puts(matches[1] + \".\" + (matches[2].to_i + 1).to_s)"')
endif

# Generate parser
default: generate

generate:
	dip rake generate

build: generate
	gem build parser.gemspec

release: clean version build push

push:
	gem push --key github --host https://rubygems.pkg.github.com/ruby-next parser-${VERSION}.gem

version:
	echo "# frozen_string_literal: true\n\nmodule Parser\n  VERSION = '${VERSION}'\nend" > lib/parser/version.rb

print-version:
	echo "New version: ${VERSION}"

clean:
	rm lib/parser/ruby*.rb
	rm *.gem
