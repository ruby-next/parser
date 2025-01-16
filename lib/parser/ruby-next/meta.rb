# frozen_string_literal: true

require "parser/meta"

module Parser
  # Parser metadata
  module Meta
    # This is how you can add new node types to the parser
    #
    # NEXT_NODE_TYPES = (NODE_TYPES + %i[meth_ref]).to_set.freeze

    # remove_const(:NODE_TYPES)
    # const_set(:NODE_TYPES, NEXT_NODE_TYPES)
  end
end
