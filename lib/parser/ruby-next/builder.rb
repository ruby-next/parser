# frozen_string_literal: true

require "parser/builders/default"
require_relative "meta"

module Parser
  # Add RubyNext specific builder methods
  module Builders::Next
    def match_var(var)
      return super(var) unless var.is_a?(::Parser::AST::Node)

      n(:match_var, [ var ],
        var_send_map(var))
    end

    def check_reserved_for_numparam(name, loc)
      # We don't want to raise SyntaxError, 'cause we want to use _x vars for older Rubies.
      # The exception should be raised by Ruby itself for versions supporting numbered parameters
    end
  end
end
