# frozen_string_literal: true

require "parser/ast/processor"

# Processor extensions
module Parser
  module AST
    class Processor
      alias on_def_e on_def
      alias on_defs_e on_defs
    end
  end
end
