defmodule Expression do
  @moduledoc """
  Base module to represent an signed formula from classical
  propositional logic as a (kind of ?) AST
  """

  @typedoc """
  A unsigned formula in the format {:operator, :operand, :operand}
  """
  @type formula :: {atom(), atom() | formula(), atom() | formula()}

  @typedoc """
  A signed formula from classical propositional formula
  """
  @type t :: %{
          sign: :T | :F,
          formula: formula()
        }
end
