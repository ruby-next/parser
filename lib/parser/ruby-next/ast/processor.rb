# frozen_string_literal: true

require "parser/ast/processor"

# Processor extensions
module Parser
  module AST
    class Processor
      unless method_defined?(:on_def_e)
        alias on_def_e    on_def
        alias on_defs_e   on_defs
      end

      unless method_defined?(:on_rasgn)
        alias on_rasgn    process_regular_node
        alias on_mrasgn   process_regular_node
      end
    end
  end
end
