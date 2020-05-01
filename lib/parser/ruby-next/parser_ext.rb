# frozen_string_literal: true

require_relative "lexer"
require_relative "builder"
require_relative "source/map/endless_definition" unless defined?(Parser::Source::Map::EndlessDefinition)
require_relative "ast/processor"

module Parser
  # Patch the base parser class to use custom builder and lexer
  module NextExt
    def initialize(*)
      super

      # Extend builder
      @builder.singleton_class.prepend(Builders::Next)

      # Use custom lexer
      @lexer = Lexer::Next.new(version)
      @lexer.diagnostics = @diagnostics
      @lexer.static_env  = @static_env
      @lexer.context     = @context

      # Reset the state again
      reset
    end
  end
end
