# frozen_string_literal: true

require "parser/ast/processor"

# Processor extensions
module Parser
  module AST
    class Processor
      unless method_defined?(:on_meth_ref)
        def on_meth_ref(node)
          node
        end
      end
    end
  end
end
