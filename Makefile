ifdef VERSION
else
	VERSION := $(shell sh -c 'ruby -r ./lib/parser/version.rb -e "matches = Parser::VERSION.match(/(.+)\.(\d+)\Z/); puts(matches[1] + \".\" + (matches[2].to_i + 1).to_s)"')
endif

# Generate parser
default: generate test

generate:
	dip rake --rakefile=Rakefile clean generate

test:
	dip rake --rakefile=Rakefile test

release: generate test
	gem release ruby-next-parser
	git push
	git push --tags

.PHONY: test
