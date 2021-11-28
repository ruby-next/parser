# frozen_string_literal: true

require "parser/ast/processor"

# Processor extensions
module Parser
  module AST
    class Processor
      def on_meth_ref(node)
        node
      end
    end
  end
end
