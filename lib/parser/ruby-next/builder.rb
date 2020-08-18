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

    def ipair(var)
      n(:ipair, [ var ], var.loc)
    end
  end
end
