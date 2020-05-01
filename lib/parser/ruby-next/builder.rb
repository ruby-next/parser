# frozen_string_literal: true

require "parser/builders/default"
require_relative "meta"

module Parser
  # Add RubyNext specific builder methods
  module Builders::Next
    def method_ref(receiver, dot_t, selector_t)
      n(:meth_ref, [ receiver, value(selector_t).to_sym ],
          send_map(receiver, dot_t, selector_t, nil, [], nil))
    end unless method_defined?(:method_ref)

    def def_endless_method(def_t, name_t, args,
                           assignment_t, body)
      n(:def_e, [ value(name_t).to_sym, args, body ],
      endless_definition_map(def_t, nil, name_t, assignment_t, body))
    end unless method_defined?(:def_endless_method)

    def def_endless_singleton(def_t, definee, dot_t,
                              name_t, args,
                              assignment_t, body)
      return unless validate_definee(definee)

      n(:defs_e, [ definee, value(name_t).to_sym, args, body ],
        endless_definition_map(def_t, dot_t, name_t, assignment_t, body))
    end unless method_defined?(:def_endless_singleton)

    def rassign(lhs, assoc_t, rhs)
      n(:rasgn, [lhs, rhs], binary_op_map(lhs, assoc_t, rhs))
    end unless method_defined?(:rassign)

    def multi_rassign(lhs, assoc_t, rhs)
      n(:mrasgn, [ lhs, rhs ],
        binary_op_map(lhs, assoc_t, rhs))
    end unless method_defined?(:multi_rassign)

    private

    def endless_definition_map(keyword_t, operator_t, name_t, assignment_t, body_e)
      body_l = body_e.loc.expression

      Source::Map::EndlessDefinition.new(loc(keyword_t),
                                          loc(operator_t), loc(name_t),
                                          loc(assignment_t), body_l)
    end unless private_method_defined?(:endless_definition_map)

    def validate_definee(definee)
      case definee.type
      when :int, :str, :dstr, :sym, :dsym,
            :regexp, :array, :hash

        diagnostic :error, :singleton_literal, nil, definee.loc.expression
        false
      else
        true
      end
    end unless private_method_defined?(:validate_definee)
  end
end
