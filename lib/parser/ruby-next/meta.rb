# frozen_string_literal: true

require "parser/meta"

module Parser
  # Parser metadata
  module Meta
    NEXT_NODE_TYPES = (NODE_TYPES + %i[meth_ref rasgn mrasgn]).to_set.freeze

    remove_const(:NODE_TYPES)
    const_set(:NODE_TYPES, NEXT_NODE_TYPES)
  end
end
