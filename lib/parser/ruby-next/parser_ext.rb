# frozen_string_literal: true


# if RUBY_ENGINE == 'truffleruby'
#   require_relative "lexer-F0"
# else
#   require_relative "lexer-F1"
# end
require_relative "builder"
require_relative "ast/processor"

require "parser/context"
unless Parser::Context::FLAGS.include?(:cant_return)
  Parser::Context::FLAGS << :cant_return

  class Parser::Context
    attr_accessor :cant_return
  end
end

module Parser
  # Patch the base parser class to use custom builder and lexer
  module NextExt
    def initialize(*)
      super

      # Extend builder
      @builder.singleton_class.prepend(Builders::Next)

      # Here is how to use a custom lexer
      #
      # @lexer = Lexer::Next.new(version)
      # @lexer.diagnostics = @diagnostics
      # @lexer.static_env  = @static_env
      # @lexer.context     = @context

      # Reset the state again
      reset
    end
  end
end
