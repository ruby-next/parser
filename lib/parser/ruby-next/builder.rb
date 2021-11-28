# frozen_string_literal: true

require "parser/builders/default"
require_relative "meta"

module Parser
  # Add RubyNext specific builder methods
  module Builders::Next
    def method_ref(receiver, dot_t, selector_t)
      n(:meth_ref, [ receiver, value(selector_t).to_sym ],
          send_map(receiver, dot_t, selector_t, nil, [], nil))
    end

    def check_reserved_for_numparam(name, loc)
      # We don't want to raise SyntaxError, 'cause we want to use _x vars for older Rubies.
      # The exception should be raised by Ruby itself for versions supporting numbered parameters
    end
  end
end
