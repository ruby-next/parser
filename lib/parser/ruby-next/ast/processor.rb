# frozen_string_literal: true

require "parser/ast/processor"

# Processor extensions
module Parser
  module AST
    class Processor
      alias on_def_e    on_def
      alias on_defs_e   on_defs

      alias on_rasgn    process_regular_node
      alias on_mrasgn   process_regular_node
    end
  end
end
